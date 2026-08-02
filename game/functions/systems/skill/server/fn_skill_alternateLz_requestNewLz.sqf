/*
    File: fn_skill_alternateLz_requestNewLz.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Server-side handler for the Alternate LZ skill. Selects a different LZ
        from the mission's zone and redirects the extraction helicopter to it.
        Picks the next-closest LZ that isn't the current one.

    Parameter(s):
        _missionId - ID of the current mission [STRING]
        _caller - Player who requested the alternate LZ [OBJECT]

    Returns:
        Nothing

    Example(s):
        [_missionId, _caller] call vgm_s_fnc_skill_alternateLz_requestNewLz
 */

params ["_missionId", "_caller"];

if (!isServer) exitWith {};

// Get mission data
private _allMissions = [] call vgm_s_fnc_missions_getAllMissions;
private _missionIndex = _allMissions findIf {(_x get "id") isEqualTo _missionId};
if (_missionIndex == -1) exitWith {
    format ["Alternate LZ: Mission %1 not found", _missionId] call vgm_g_fnc_logWarning;
};

private _mission = _allMissions # _missionIndex;
private _missionPublic = _mission get "public";
private _targetBox = _missionPublic get "targetZone";

// Get all available LZs for this zone
private _lzs = [_targetBox] call vgm_g_fnc_missions_zones_getLzs;

if (count _lzs < 2) exitWith {
    format ["Alternate LZ: Not enough LZs available in zone"] call vgm_g_fnc_logWarning;
};

// Get extraction helicopter from player group (matches extraction system)
private _playerGroup = _missionPublic get "group";
private _helicopter = _playerGroup getVariable ["vgm_missions_extraction_helicopter", objNull];

if (isNull _helicopter || !alive _helicopter) exitWith {
    format ["Alternate LZ: No active extraction helicopter"] call vgm_g_fnc_logWarning;
};

// Get current helipad from helicopter (matches extraction_scriptedLand)
private _currentHelipad = _helicopter getVariable ["vgm_mission_extraction_helipad", objNull];
private _currentLzPos = if (!isNull _currentHelipad) then {getPosATL _currentHelipad} else {[0,0,0]};

// Sort LZs by distance to caller, excluding the current one
// Also exclude any compromised LZs (alternate is guaranteed clean)
private _callerPos = getPosATL _caller;
private _validLzs = _lzs select {
    _x distance2D _currentLzPos > 50 &&
    {!(format ["%1_%2", _missionId, hashValue _x] in vgm_s_compromisedLz_occupiedLzs)}
};

if (_validLzs isEqualTo []) exitWith {
    format ["Alternate LZ: No alternate LZs available"] call vgm_g_fnc_logWarning;
};

private _lzsByDistance = _validLzs apply {[_x distance2D _callerPos, _x]};
_lzsByDistance sort true;

private _newLzPos = _lzsByDistance # 0 # 1;

// If helicopter is orbiting a compromised LZ, clear the orbit flag
// so the extraction monitor detects the alternate and transitions
if (_helicopter getVariable ["vgm_compromisedLz_orbiting", false]) then {
    _helicopter setVariable ["vgm_compromisedLz_orbiting", false, true];
    format ["Alternate LZ: Clearing compromised orbit, redirecting to clean LZ at %1", _newLzPos] call vgm_g_fnc_logInfo;
};

// Delete old helipad and create invisible one at new LZ
if (!isNull _currentHelipad) then {
    deleteVehicle _currentHelipad;
};

private _newPad = createVehicle ["HeliH", _newLzPos, [], 0, "CAN_COLLIDE"];
_newPad setPosATL _newLzPos;

// Store new helipad on helicopter (matches extraction system convention)
_helicopter setVariable ["vgm_mission_extraction_helipad", _newPad];

// Redirect helicopter to new LZ — scriptedLand handles cleanup and landAt
[_helicopter] call vgm_s_fnc_missions_gameplay_extraction_scriptedLand;

format ["Alternate LZ: New LZ selected at %1 by %2", _newLzPos, name _caller] call vgm_g_fnc_logInfo;
