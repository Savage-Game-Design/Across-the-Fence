/*
    File: fn_missions_onMissionEnd.sqf
    Author: Savage Game Design
    Date: 2023-02-26
    Last Update: 2023-06-20
    Public: No

    Description:
        Handles the end of the mission on the client.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] remoteExecCall ["vgm_c_fnc_missions_onMissionEnd", _playersOnMission];

        // Should be triggered by ending the mission on the server.
        [] call vgm_s_fnc_missions_onMissionEnd;
 */

player setPos ([] call vgm_g_fnc_missions_getHubSpawnPos);

[nil] call vgm_c_fnc_missions_setCurrentMission;

// Show end of mission screen
