/*
    File: fn_zombie_hasChaseTarget.sqf
    Author: Savage Game Design
    Date: 2025-10-20
    Last Update: 2025-10-29
    Public: No

    Description:
        Checks if the zombie has a chase target, and that the target is valid

    Parameter(s):
        _zombie - Unit to use [UNIT]

    Returns:
        True if the zombie has a valid chase target [BOOL]

    Example(s):
        [_zombie] call vgm_g_fnc_zombie_hasChaseTarget;
 */

params ["_zombie"];

[_zombie, _zombie getVariable ["vgm_l_zombie_chaseTarget", objNull]] call vgm_g_fnc_zombie_isValidTarget
