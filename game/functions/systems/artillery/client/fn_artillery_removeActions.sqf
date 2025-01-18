/*
    File: fn_artillery_addActions.sqf
    Author: Savage Game Design and Ethan Johnson
    Date: 2024-11-09
    Last Update: 2025-01-17
    Public: Yes

    Description:
        Removes artillery actions (and event handlers) from player.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_artillery_removeActions;
 */

player removeAction (player getVariable ["vgm_c_artillery_actionId", -1]);
player removeEventHandler ["Respawn", player getVariable ["vgm_c_artillery_respawnHandlerId", -1]];
player removeEventHandler ["Killed", player getVariable ["vgm_c_artillery_killedHandlerId", -1]];

player setVariable ["vgm_c_artillery_actionId", nil];
player setVariable ["vgm_c_artillery_respawnHandlerId", -1];
player setVariable ["vgm_c_artillery_killedHandlerId", -1];
