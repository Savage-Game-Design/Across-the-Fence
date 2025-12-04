/*
    File: fn_respawn_setMissionRallyPoint.sqf
    Author: Savage Game Design
    Date: 2025-12-03
    Last Update: 2025-12-03
    Public: Yes

    Description:
        Sets the rally point for a given mission, which respawns center around.

    Parameter(s):
        _missionId - ID of the mission [NUMBER]
        _rallyPosATL - Position of the rally point, ATL format [ARRAY]

    Returns:
        Nothing

    Example(s):
        [[_player] call vgm_g_fnc_missions_getAssignedMissionId, getPosATL _player] call vgm_s_fnc_respawn_setMissionRallyPoint;
 */

params [
    ["_missionId", nil, [1]],
    ["_rallyPosATL", nil, [[]]]
];

private _mission = [_missionId] call vgm_s_fnc_missions_getById;

if (isNil "_mission") exitWith {
    ["Attempted to set rally point for non-existent mission %1", _missionId] call vgm_g_fnc_logWarning;
};

["[Respawn] Setting rally point for mission %1 to %2", _missionId, _rallyPosATL] call vgm_g_fnc_logDebug;

// Store in the mission netmap so it's auto-erased at the end of the mission, and can only be set while on a mission.
private _respawnNetmap = [_missionId, "respawn"] call vgm_s_fnc_missions_getSystemNetmap;

[_respawnNetmap, "rallyPosATL", _rallyPosATL] call para_s_fnc_netmap_set;
