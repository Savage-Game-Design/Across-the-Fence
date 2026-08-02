/*
    File: fn_artillery_addActions.sqf
    Author: Savage Game Design and Ethan Johnson
    Date: 2024-11-09
    Last Update: 2026-03-04
    Public: No

    Description:
        Sets up respawn/killed handlers for the artillery system.
        The scrollwheel addAction has been moved to the wheel menu
        (cfg_wheel_menu.hpp). This function handles:
        - Respawn handler to re-add event handlers
        - Killed handler to force-close the artillery display

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_artillery_addActions;
 */

// Only add event handlers once
if ((player getVariable ["vgm_c_artillery_respawnHandlerId", -1]) > -1) exitWith {};

private _newRespawnHandler = player addEventHandler ["Respawn", {
    params ["_unit", "_corpse"];
    [] call vgm_c_fnc_artillery_addActions;
}];
player setVariable ["vgm_c_artillery_respawnHandlerId", _newRespawnHandler];

// Force close the display when the player dies.
private _newKilledHandler = player addEventHandler ["Killed", {
    (uiNamespace getVariable ["vn_artillery_display",displayNull]) closeDisplay 0;
}];
player setVariable ["vgm_c_artillery_killedHandlerId",_newKilledHandler];
