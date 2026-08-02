/*
    File: fn_missions_gameplay_snatch_onMissionEnded.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Handles cleanup when a Prisoner Snatch mission ends.
        Deletes spawned officer and guards, removes tasks.

    Parameter(s):
        _missionId - Id of the mission [NUMBER]

    Returns:
        Nothing

    Example(s):
        [_missionId] call vgm_s_fnc_missions_gameplay_snatch_onMissionEnded
 */

params ["_missionId"];

private _mission = [_missionId] call vgm_s_fnc_missions_getById;
if (isNil "_mission") exitWith {};

private _missionType = (_mission get "parameters") getOrDefault ["missionType", "scouting"];
if (_missionType != "prisoner_snatch") exitWith {};

private _snatchNetmap = [_missionId, "snatch"] call vgm_s_fnc_missions_getSystemNetmap;
if (isNil "_snatchNetmap") exitWith {};

// Delete officer
private _officer = _snatchNetmap get "officer";
if (!isNil "_officer" && {!isNull _officer}) then {
    deleteVehicle _officer;
};

// Delete guards
private _guards = _snatchNetmap getOrDefault ["guards", []];
{
    if (!isNull _x) then {deleteVehicle _x};
} forEach _guards;

// Mark incomplete subtasks as FAILED before cleanup
private _targetExtracted = _snatchNetmap getOrDefault ["targetExtracted", false];
if (!_targetExtracted) then {
    private _parentTaskId = format ["vgm_snatch_%1", _missionId];
    [format ["%1_extract", _parentTaskId], "FAILED"] call BIS_fnc_taskSetState;
    [_parentTaskId, "FAILED"] call BIS_fnc_taskSetState;
    format ["Snatch: Officer not extracted for mission %1 — objective failed", _missionId] call vgm_g_fnc_logInfo;
};

// Delete tasks
[
    format ["vgm_snatch_%1", _missionId],
    true,
    true
] call BIS_fnc_deleteTask;

format ["Snatch: Cleaned up mission %1", _missionId] call vgm_g_fnc_logInfo;
