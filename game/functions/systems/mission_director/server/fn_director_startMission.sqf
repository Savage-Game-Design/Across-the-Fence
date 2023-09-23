/*
    File: fn_director_startMission.sqf
    Author: Savage Game Design
    Date: 2023-09-23
    Last Update: 2023-09-24
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

[] remoteExec ["vgm_c_fnc_director_startClientsideMonitoring", values (_mission get "machineIds")];

// TODO - Start clientside monitoring on JIP players
// Use startDeploy and finishDeploy as events for ease of use.



