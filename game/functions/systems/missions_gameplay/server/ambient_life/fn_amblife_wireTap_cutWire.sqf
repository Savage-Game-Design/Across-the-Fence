/*
    File: fn_amblife_wireTap_cutWire.sqf
    Author: AtlasActual
    Date: 2026-03-05
    Last Update: 2026-03-05
    Public: No

    Description:
        Server handler for cutting a wire tap junction box. Awards 50 XP and
        halves the alertness gain rate for 10 minutes. If already active,
        extends the expiry by 5 minutes without stacking the multiplier.

    Parameter(s):
        _target - The junction box object [OBJECT]
        _caller - The player who cut the wire [OBJECT]

    Returns:
        Nothing

    Example(s):
        [_target, _caller] remoteExecCall ["vgm_s_fnc_amblife_wireTap_cutWire", 2]
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

// Award 50 XP
[_caller, 50] call vgm_s_fnc_leveling_addExperience;

// Apply or extend gain modifier on director data
private _directorData = [_missionId] call vgm_s_fnc_director_getDirectorForMissionId;
if (!isNil "_directorData") then {
	private _existingMod = _directorData getOrDefault ["wireTapGainModifier", 1];
	private _existingExp = _directorData getOrDefault ["wireTapGainModifierExpiry", 0];

	if (_existingMod < 1 && {serverTime < _existingExp}) then {
		// Already active: extend expiry by 300s, don't stack multiplier
		_directorData set ["wireTapGainModifierExpiry", _existingExp + 300];
	} else {
		// New activation: 50% gain for 600s
		_directorData set ["wireTapGainModifier", 0.5];
		_directorData set ["wireTapGainModifierExpiry", serverTime + 600];
	};
};

// Notify all mission players
private _players = [_mission] call vgm_s_fnc_missions_getPlayers;
{
	["Wire Cut: Enemy communications disrupted. Alertness gain halved for 10 minutes."] remoteExecCall ["hint", _x];
} forEach _players;

format ["[AmbLife] Wire tap: %1 cut wire at %2 for mission %3", name _caller, getPos _target, _missionId] call vgm_g_fnc_logInfo;
