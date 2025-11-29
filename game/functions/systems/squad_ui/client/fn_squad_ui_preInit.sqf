/*
    File: fn_squad_ui_preInit.sqf
    Author: Savage Game Design
    Date: 2024-07-04
    Last Update: 2025-11-29
    Public: No

    Description:
        Squad UI component client pre init.
 */

if (!hasInterface) exitWith {};

vgm_squad_ui_mapDrawEveryone = false;

["squadUiMapDrawEveryone", {
    params ["", "_inEffect"];

    vgm_squad_ui_mapDrawEveryone = _inEffect;
}] call vgm_c_fnc_statusEffect_create;
