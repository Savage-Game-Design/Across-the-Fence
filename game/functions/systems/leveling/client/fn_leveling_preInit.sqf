/*
    File: fn_preInit.sqf
    Author: Savage Game Design
    Date: 2023-05-30
    Last Update: 2023-09-09
    Public: No

    Description:
        Client preInit function for leveling system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

if (!hasInterface) exitWith {};

["vgm_leveling_updateData", {
    params ["_levelingData"];

    player setVariable ["vgm_g_levelingData", _levelingData];
}] call para_g_fnc_event_subscribeServer;

["leveling", {
    !isNil {player getVariable "vgm_g_levelingData"}
}] call vgm_c_fnc_loading_addHandler;
