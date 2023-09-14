/*
    File: fn_missions_onMissionEnd.sqf
    Author: Savage Game Design
    Date: 2023-02-26
    Last Update: 2023-09-08
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

// Removes player-specific tracker module handlers.
// TODO: Remove when switching to full AI system.
player removeEventHandler ["Fired", player getVariable "vgm_c_trackerFiredHandler"];
["ItemRemove", ["vn_tracksLoop"]] call BIS_fnc_loop;

player setPos ([] call vgm_g_fnc_missions_getHubSpawnPos);

// Show end of mission screen
