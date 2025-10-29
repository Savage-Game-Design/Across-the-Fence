/*
    File: fn_zombie_clearChaseTarget.sqf
    Author: Savage Game Design
    Date: 2025-10-20
    Last Update: 2025-10-29
    Public: No

    Description:
        Clears the zombie's current chase target

    Parameter(s):
        _zombie - Unit to use [UNIT]

    Returns:
        Nothing

    Example(s):
        [_zombie] call vgm_g_fnc_zombie_clearChaseTarget;
 */

params ["_zombie"];

_zombie setVariable ["vgm_l_zombie_chaseTarget", nil];
