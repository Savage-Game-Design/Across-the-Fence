#include "script_component.inc"
/*
    File: fn_sites_hints_preInit.sqf
    Author: Savage Game Design
    Date: 2024-10-30
    Last Update: 2025-01-10
    Public: No

    Description:
        Client PostInit for the site hints system.
 */

if (!hasInterface || is3DEN) exitWith {};

vgm_c_sites_hints_lastGlint = 0;

["sites_hints_glint", {isNil {call vgm_c_fnc_sites_hints_glintJob}}, [], 5] call para_g_fnc_scheduler_add_job;

[] call vgm_c_fnc_sites_hints_inspectInit;
player addEventHandler ["Respawn", {[] call vgm_c_fnc_sites_hints_inspectInit}];
