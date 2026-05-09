/*
    File: fn_quickstart_postInit.sqf
    Author: Savage Game Design
    Date: 2026-05-09
    Last Update: 2026-05-09
    Public: No

    Description:
        Post init function for the quickstart gamemode variant.

 */


// Make players more resilient
[player, "hitShrug", "quickstart", 0.5, true] call vgm_c_fnc_coefficient_set;
