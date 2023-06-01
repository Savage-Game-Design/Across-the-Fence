/*
    File: fn_postInit.sqf
    Author: veteran29
    Date: 2023-05-30
    Last Update: 2023-06-01
    Public: No

    Description:
        Client postInit function for leveling system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

if (!hasInterface) exitWith {};

["vgm_leveling_init", player] call para_g_fnc_event_triggerServer;
