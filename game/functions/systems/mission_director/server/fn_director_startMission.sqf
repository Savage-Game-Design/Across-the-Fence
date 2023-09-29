/*
    File: fn_director_startMission.sqf
    Author: Savage Game Design
    Date: 2023-09-23
    Last Update: 2023-09-29
    Public: Yes

    Description:
        Starts the mission director running on a new mission.

        Generally, this should be called when a mission is started, as the players are deploying.

        Handles:
            - Mission asset creation
            - Overall mission flow
            - AI quantities and behaviour
            - Ending the mission

    Parameter(s):
        _mission - Mission to monitor [HashMap]

    Returns:
        Nothing

    Example(s):
        [_mission] call vgm_s_fnc_director_startMission
 */

params ["_mission"];

private _directorData = _mission getOrDefault ["director", createHashMap, true];

// Explosions reported by other systems / clients. Processed during the main loop.
_directorData set ["explosionIngestionQueue", []];
// Shots reported by other systems / clients. Processed during the main loop.
_directorData set ["shotsIngestionQueue", []];
// AI groups that currently exist on this mission
_directorData set ["aiGroups", []];

[] remoteExec ["vgm_c_fnc_director_startClientsideMonitoring", values (_mission get "machineIds")];

[_mission] call vgm_s_fnc_director_spawnInitialPatrols;

private _jobId = format ["missionDirector%1", _mission get "public" get "id"];
[_jobId, { _this call vgm_s_fnc_director_processMission }, [_mission], 10] call para_g_fnc_scheduler_add_job;

_directorData set ["schedulerJob", _jobId];

// TODO - Start clientside monitoring on JIP players
// Use startDeploy and finishDeploy as events for ease of use.



