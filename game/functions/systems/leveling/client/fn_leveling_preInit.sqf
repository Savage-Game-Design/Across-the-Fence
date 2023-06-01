/*
    File: fn_preInit.sqf
    Author: veteran29
    Date: 2023-05-30
    Last Update: 2023-06-01
    Public: No

    Description:
        Client preInit function for leveling system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

if (!hasInterface) exitWith {};

["vgm_leveling_initClient", {
    params ["_levelingData"];
    player setVariable ["vgm_g_levelingData", _levelingData];
}] call para_g_fnc_event_subscribeServer;
