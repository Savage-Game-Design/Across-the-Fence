/*
    File: fn_display_preInit.sqf
    Author: Savage Game Design
    Date: 2024-03-24
    Last Update: 2024-03-24
    Public: No

    Description:
        PreInit for display related functionalities.
 */

[true, "arsenalClosed", {
    if (isNil "vgm_display_reopen") exitWith {};
    createDialog vgm_display_reopen;
    vgm_display_reopen = nil;
}] call BIS_fnc_addScriptedEventHandler;
