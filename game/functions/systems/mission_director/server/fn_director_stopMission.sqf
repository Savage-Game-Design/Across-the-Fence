/*
    File: fn_director_stopMonitoringMission.sqf
    Author: Savage Game Design
    Date: 2023-09-23
    Last Update: 2023-09-24
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

[] remoteExec ["vgm_c_fnc_director_stopClientsideMonitoring", values (_mission get "machineIds")];
