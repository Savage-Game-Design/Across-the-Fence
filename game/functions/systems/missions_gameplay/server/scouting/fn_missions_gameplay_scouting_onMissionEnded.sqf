/*
    File: fn_missions_gameplay_scouting_onMissionEnded.sqf
    Author: Savage Game Design
    Date: 2024-12-06
    Last Update: 2024-12-06
    Public: No

    Description:
        Handle mission end.

    Parameter(s):
        _missionId - Id of the mission [NUMBER]

    Returns:
        Nothing

    Example(s):
        [_missionId] call vgm_s_fnc_missions_gameplay_scouting_onMissionEnded
 */

params ["_missionId"];

private _mission = [_missionId] call vgm_s_fnc_missions_getById;

if (isNil "_mission") exitWith {
    format ["Mission does not exist: %1", _missionId] call vgm_g_fnc_logError;
};

[
    format ["vgm_scout_%1", _mission get "public" get "id"],
    true,
    true
] call BIS_fnc_deleteTask;
