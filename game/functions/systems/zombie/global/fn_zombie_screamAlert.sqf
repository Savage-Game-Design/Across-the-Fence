/*
    File: fn_zombie_screamAlert.sqf
    Author: Savage Game Design
    Date: 2025-10-22
    Last Update: 2025-10-29
    Public: No

    Description:
        Emits a zombie "scream", triggering an event that can be picked up by other zombies and systems.

    Parameter(s):
        _zombie - Zombie to use [UNIT]

    Returns:
        Nothing

    Example(s):
        [cursorObject] call vgm_g_fnc_zombie_screamAlert;
 */

params ["_zombie"];

_zombie spawn {
    private _zombie = _this;
    private _sound = format ["ryanzombies\sounds\aggressive_spider%1.ogg", selectRandom ["37", "38", "39", "40"]];
    [_zombie, _sound, 2] call vgm_g_fnc_zombie_makeNoise;

    sleep 2;

    if (!alive _zombie) exitWith {};
    [
        group _zombie getVariable "vgm_g_missionId",
        getPosATL _zombie,
        vgm_g_zombie_screamAlertRadius,
        "zombie_alert",
        []
    ] call vgm_g_fnc_locEvents_triggerEvent;
};
