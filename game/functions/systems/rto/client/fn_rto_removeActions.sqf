/*
    File: fn_rto_addActions.sqf
    Author: Savage Game Design and Ethan Johnson
    Date: 2024-11-09
    Last Update: 2026-01-25
    Public: Yes

    Description:
        Removes RTO actions (and event handlers) from player.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_rto_removeActions;
 */

player removeAction (player getVariable ["vgm_c_rto_actionId", -1]);
player removeEventHandler ["Respawn", player getVariable ["vgm_c_rto_respawnHandlerId", -1]];
player removeEventHandler ["Killed", player getVariable ["vgm_c_rto_killedHandlerId", -1]];

player setVariable ["vgm_c_rto_actionId", nil];
player setVariable ["vgm_c_rto_respawnHandlerId", -1];
player setVariable ["vgm_c_rto_killedHandlerId", -1];
