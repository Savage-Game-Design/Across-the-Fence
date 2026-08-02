/*
    File: fn_skillPresets_preInit.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Client preInit for the skill presets system.
        Adds the "Skill Presets" action to skill objects when persistence is loaded.

    Parameter(s):
        N/A

    Returns:
        Nothing
*/

if (!hasInterface) exitWith {};

// Initialize local preset cache
vgm_c_skillPresets_data = createHashMap;

// Add actions on skill objects after persistence is ready
["vgm_persistence_loaded", {
    [] call vgm_c_fnc_skillPresets_addAction;
}] call para_g_fnc_event_subscribeServer;
