/*
    File: fn_respawn_clearMissionRallyPoint.sqf
    Author: Savage Game Design
    Date: 2025-12-03
    Last Update: 2025-12-04
    Public: Yes

    Description:
        Clears the rally point for a given mission

    Parameter(s):
        _missionId - ID of the mission [NUMBER]

    Returns:
        Nothing

    Example(s):
        [[_player] call vgm_g_fnc_missions_getAssignedMissionId] call vgm_s_fnc_respawn_clearMissionRallyPoint;
 */

params [
    ["_missionId", nil, [1]]
];

private _mission = [_missionId] call vgm_s_fnc_missions_getById;

if (isNil "_mission") exitWith {
    ["Attempted to clear rally point for non-existent mission %1", _missionId] call vgm_g_fnc_logWarning;
};

["[Respawn] Clearing rally point for mission", _missionId, _rallyPosATL] call vgm_g_fnc_logDebug;

private _respawnNetmap = [_missionId, "respawn"] call vgm_s_fnc_missions_getSystemNetmap;

[_respawnNetmap, "rallyPosATL"] call para_s_fnc_netmap_deleteAt;
