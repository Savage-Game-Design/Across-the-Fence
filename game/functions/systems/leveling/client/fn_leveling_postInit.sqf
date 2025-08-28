/*
    File: fn_postInit.sqf
    Author: Savage Game Design
    Date: 2023-05-30
    Last Update: 2025-08-28
    Public: No

    Description:
        Client postInit function for leveling system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

if (!hasInterface) exitWith {};

[{
    // request system init from the server
    ["vgm_leveling_init", player] call para_g_fnc_event_triggerServer;
}] call vgm_c_fnc_persistence_addHandler;
