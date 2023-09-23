/*
    File: fn_missions_reportFiredDataToServer.sqf
    Author: Savage Game Design
    Date: 2023-09-23
    Last Update: 2023-09-24
    Public: No

    Description:
        Sends an aggregate of recent shots fired on the client to the server.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_director_sendRecentShotsToServer;
 */

[
    "vgm_director_recentPlayerShots",
    vgm_c_director_recentShots
] call para_g_fnc_event_triggerServer;

// Reset all values to default for the next time period.
vgm_c_director_recentShots = +vgm_c_director_recentShotsTemplate;
