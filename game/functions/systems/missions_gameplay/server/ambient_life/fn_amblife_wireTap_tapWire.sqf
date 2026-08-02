/*
    File: fn_amblife_wireTap_tapWire.sqf
    Author: AtlasActual
    Date: 2026-03-05
    Last Update: 2026-03-05
    Public: No

    Description:
        Server handler for tapping a wire tap junction box. Validates the caller,
        reveals 1-2 approximate site positions (offset 50-150m) to mission players,
        awards 150 XP, and reduces alertness by -3.

    Parameter(s):
        _target - The junction box object [OBJECT]
        _caller - The player who tapped the wire [OBJECT]

    Returns:
        Nothing

    Example(s):
        [_target, _caller] remoteExecCall ["vgm_s_fnc_amblife_wireTap_tapWire", 2]
 */

if (!isServer) exitWith {};

params ["_target", "_caller"];

// Validate
if (isNull _target || {isNull _caller}) exitWith {};
if (_target getVariable ["vgm_wireTap_used", false]) exitWith {};

// Mark as used globally
_target setVariable ["vgm_wireTap_active", false, true];
_target setVariable ["vgm_wireTap_used", true, true];

// Get mission data
private _missionId = _target getVariable ["vgm_wireTap_missionId", -1];
if (_missionId < 0) exitWith {};

private _mission = [_missionId] call vgm_s_fnc_missions_getById;
if (isNil "_mission") exitWith {};

// Award 150 XP
[_caller, 150] call vgm_s_fnc_leveling_addExperience;

// Reduce alertness by -3
private _directorData = [_missionId] call vgm_s_fnc_director_getDirectorForMissionId;
if (!isNil "_directorData") then {
	[_directorData, -3] call vgm_s_fnc_director_addAlertness;
};

// Reveal 1-2 site positions (offset 50-150m) to all mission players
private _targetZone = _mission get "public" get "targetZone";
private _sites = [_targetZone] call vgm_s_fnc_missions_zones_getSites;
private _zone = _mission call vgm_g_fnc_missions_getZoneMarker;

if (count _sites > 0) then {
	private _revealCount = 1 + floor random (count _sites min 2);
	private _shuffled = +_sites;
	_shuffled = _shuffled call BIS_fnc_arrayShuffle;
	private _intelData = [];

	for "_i" from 0 to (_revealCount - 1) do {
		if (_i >= count _shuffled) exitWith {};
		private _sitePos = (_shuffled # _i) get "pos";

		// Generate offset position 50-150m from actual site
		private _validPos = [];
		for "_p" from 0 to 10 do {
			private _pos = [_sitePos, 150, 50] call vgm_g_fnc_randomPosInRing;
			if (_pos inArea _zone) exitWith { _validPos = _pos };
		};

		if !(_validPos isEqualTo []) then {
			_intelData pushBack ["area", _validPos];
		};
	};

	// Send intel markers to all mission players
	if (count _intelData > 0) then {
		private _players = [_mission] call vgm_s_fnc_missions_getPlayers;
		{
			[_intelData] remoteExecCall ["vgm_c_fnc_skill_targetFolder_showMarkers", _x];
		} forEach _players;
	};
};

format ["[AmbLife] Wire tap: %1 tapped wire at %2, revealed intel for mission %3", name _caller, getPos _target, _missionId] call vgm_g_fnc_logInfo;
