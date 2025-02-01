/*
    File: fn_director_stopMonitoringMission.sqf
    Author: Savage Game Design
    Date: 2023-09-23
    Last Update: 2025-01-16
    Public: Yes

    Description:
        Called to stop the mission director running on a mission.

        Generally, this should be called when a mission has ended, and the players are back at base.

        Handles:
            - Despawning mission assets
            - Cleaning up AI
            - Shutting down regular loops / event handlers / etc

    Parameter(s):
        _mission - Mission to cleanup [HashMap]

    Returns:
        Nothing

    Example(s):
        [_mission] call vgm_s_fnc_director_stopMission;
 */

params ["_mission"];

private _machineIds = values (_mission get "machineIds");
if (_machineIds isNotEqualTo []) then {
    [] remoteExec ["vgm_c_fnc_director_stopClientsideMonitoring", _machineIds];
};


private _directorData = _mission get "director";
if (isNil "_directorData") exitWith {}; // mission was not started, no data

{
    [_x] call vgm_s_fnc_virtsquad_delete;
} forEach values (_directorData getOrDefault ["virtualSquads", createHashMap]);

// Removes the job from the scheduler after it next runs.
[_directorData get "schedulerJob"] call para_g_fnc_scheduler_remove_job;

{
    [_x] call vgm_g_fnc_locEvents_removeHandlers;
} forEach (_directorData get "locEventHandlers");
