/*
    File: fn_director_preinit.sqf
    Author: Savage Game Design
    Date: 2023-09-23
    Last Update: 2023-09-24
    Public: No

    Description:
        Preinit for the mission director system

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] call vgm_s_fnc_director_preinit;
 */

[
    "vgm_director_playerCausedExplosion",
    // Wrapped in code block to allow recompilation when testing.
    { _this call vgm_s_fnc_director_handlePlayerExplosion }
] call para_g_fnc_event_subscribe;

[
    "vgm_director_recentPlayerShots",
    // Wrapped in code block to allow recompilation when testing.
    { _this call vgm_s_fnc_director_handlePlayerShots }
] call para_g_fnc_event_subscribe;
