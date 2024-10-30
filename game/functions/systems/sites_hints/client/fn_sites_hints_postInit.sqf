/*
    File: fn_sites_hints_preInit.sqf
    Author: Savage Game Design
    Date: 2024-10-30
    Last Update: 2024-10-31
    Public: No

    Description:
        Client PostInit for the site hints system.
 */

if (!hasInterface) exitWith {};

["sites_hints_glint", {isNil {call vgm_c_fnc_sites_hints_glintJob}}, [], 30] call para_g_fnc_scheduler_add_job;
