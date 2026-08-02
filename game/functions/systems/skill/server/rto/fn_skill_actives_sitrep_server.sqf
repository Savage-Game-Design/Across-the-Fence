/*
    File: fn_skill_actives_sitrep_server.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Server-side handler for Sitrep skill.
        Reads alertness from the mission director and finds nearest enemy info.
        Sends the data back to the requesting player.

    Parameter(s):
        _requestingPlayer - Player who activated Sitrep [OBJECT]
        _missionId - Mission ID to query [NUMBER]

    Returns:
        Nothing

    Example(s):
        [_player, _missionId] call vgm_s_fnc_skill_actives_sitrep_server
 */

params ["_requestingPlayer", "_missionId"];

if (isNil "_missionId") exitWith {
    ["Sitrep: no mission ID provided"] call vgm_g_fnc_logWarning;
};

// Get director data for this mission
private _director = [_missionId] call vgm_s_fnc_director_getDirectorForMissionId;

private _alertness = 0;
if (!isNil "_director") then {
    _alertness = _director getOrDefault ["alertness", 0];
};

// Determine alertness label
private _alertLabel = switch (true) do {
    case (_alertness < 25): { "Low" };
    case (_alertness < 50): { "Moderate" };
    case (_alertness < 75): { "High" };
    default { "Critical" };
};

// Find nearest enemy units within 1km of the requesting player
private _playerPos = getPosATL _requestingPlayer;
private _nearEnemies = allUnits select {
    side _x == east && {_x distance _playerPos < 1000}
};

private _bearing = -1;
private _count = count _nearEnemies;

if (_count > 0) then {
    // Find closest enemy for bearing
    private _closest = _nearEnemies select 0;
    private _closestDist = _closest distance _playerPos;
    {
        private _dist = _x distance _playerPos;
        if (_dist < _closestDist) then {
            _closest = _x;
            _closestDist = _dist;
        };
    } forEach _nearEnemies;
    _bearing = _playerPos getDir _closest;
};

// Send response back to the requesting player
[_alertLabel, _alertness, _bearing, _count] remoteExecCall ["vgm_c_fnc_skill_actives_sitrep_display", _requestingPlayer];
