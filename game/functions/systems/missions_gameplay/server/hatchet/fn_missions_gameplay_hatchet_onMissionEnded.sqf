/*
    File: fn_missions_gameplay_hatchet_onMissionEnded.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Handles cleanup when a Hatchet Force mission ends.

    Parameter(s):
        _missionId - Id of the mission [NUMBER]

    Returns:
        Nothing

    Example(s):
        [_missionId] call vgm_s_fnc_missions_gameplay_hatchet_onMissionEnded
 */

params ["_missionId"];

private _mission = [_missionId] call vgm_s_fnc_missions_getById;
if (isNil "_mission") exitWith {};

private _missionType = (_mission get "parameters") getOrDefault ["missionType", "scouting"];
if (_missionType != "hatchet_force") exitWith {};

private _hatchetNetmap = [_missionId, "hatchet"] call vgm_s_fnc_missions_getSystemNetmap;
if (isNil "_hatchetNetmap") exitWith {};

// Delete recon team
private _reconTeam = _hatchetNetmap getOrDefault ["reconTeam", []];
{
    if (!isNull _x) then {deleteVehicle _x};
} forEach _reconTeam;

// Delete spawned enemies
private _spawnedEnemies = _hatchetNetmap getOrDefault ["spawnedEnemies", []];
{
    if (!isNull _x) then {deleteVehicle _x};
} forEach _spawnedEnemies;

// Mark incomplete subtasks as FAILED before cleanup
private _reconTeamRescued = _hatchetNetmap getOrDefault ["reconTeamRescued", 0];
private _reconTeamAlive = _hatchetNetmap getOrDefault ["reconTeamAlive", 0];
if (_reconTeamRescued < _reconTeamAlive || _reconTeamAlive == 0) then {
    private _parentTaskId = format ["vgm_hatchet_%1", _missionId];
    [format ["%1_extract", _parentTaskId], "FAILED"] call BIS_fnc_taskSetState;
    [_parentTaskId, "FAILED"] call BIS_fnc_taskSetState;
    format ["Hatchet: Recon team not fully extracted for mission %1 — objective failed", _missionId] call vgm_g_fnc_logInfo;
};

[
    format ["vgm_hatchet_%1", _missionId],
    true,
    true
] call BIS_fnc_deleteTask;

format ["Hatchet: Cleaned up mission %1", _missionId] call vgm_g_fnc_logInfo;
