/*
    File: fn_mortar_stop.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Stops the mortar barrage system for a mission.
        Removes the scheduler job and cleans up mortarData from directorData.

    Parameter(s):
        _mission - Mission HashMap [HashMap]

    Returns:
        Nothing

    Example(s):
        [_mission] call vgm_s_fnc_mortar_stop;
*/

params ["_mission"];

private _directorData = _mission getOrDefault ["director", createHashMap];
if (_directorData isEqualTo createHashMap) exitWith {};

private _mortarData = _directorData getOrDefault ["mortarData", createHashMap];
if (_mortarData isEqualTo createHashMap) exitWith {};

// Remove scheduler job
private _jobId = _mortarData getOrDefault ["schedulerJobId", ""];
if (_jobId != "") then {
    [_jobId] call para_g_fnc_scheduler_remove_job;
};

// Clean up mortar data
_directorData set ["mortarData", createHashMap];

private _missionId = (_mission getOrDefault ["public", createHashMap]) getOrDefault ["id", "unknown"];
[format ["[Mortar] Barrage stopped on mission %1", _missionId]] call vgm_g_fnc_logInfo;
