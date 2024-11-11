/*
    File: fn_ai_postInit.sqf
    Author: Savage Game Design
    Date: 2024-11-11
    Last Update: 2024-11-11
    Public: No

    Description:
        Client Post Init for AI behaviour subsystem.
 */

if (!hasInterface) exitWith {};

// prevent AI from gaining knowledge about players by being damaged by their mines,
// side effect is that the players do not get score for killing the AIs with them.
vgm_ai_firedMinesEh = player addEventHandler ["Fired", {
    params ["", "_weapon", "", "", "", "", "_projectile"];
    if (_weapon != "Put") exitWith {};

    private _triggerClass = getText (configOf _projectile >> "mineTrigger");
    private _triggerType = getText (configFile >> "CfgMineTriggers" >> _triggerClass >> "mineTriggerType");
    // remote explosives need ownership for the player to be able to detonate them
    if (toLower _triggerType in ["remote", "timer"]) exitWith {};

    [_projectile, [objNull, objNull]] remoteExec ["setShotParents", 2];
}];
