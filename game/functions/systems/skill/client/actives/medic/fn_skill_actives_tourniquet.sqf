/*
    File: fn_skill_actives_tourniquet.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Activates the "Tourniquet" skill.
        Instantly stops bleeding on the targeted player.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skill_actives_tourniquet
 */

params ["", "_skill"];

private _target = cursorTarget;
if (isNull _target || {!isPlayer _target}) exitWith {
    "Tourniquet: no valid target" call vgm_g_fnc_logWarning;
};

["Tourniquet skill activated"] call vgm_g_fnc_logInfo;

[_target, "bleeding", "medical"] remoteExecCall ["vgm_c_fnc_statusEffect_remove", _target];
