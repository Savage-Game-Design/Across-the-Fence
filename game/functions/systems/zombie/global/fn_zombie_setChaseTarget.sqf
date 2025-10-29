/*
    File: fn_zombie_hasChaseTarget.sqf
    Author: Savage Game Design
    Date: 2025-10-20
    Last Update: 2025-10-29
    Public: No

    Description:
        Sets a zombie's chase target.

    Parameter(s):
        _zombie - Zombie to use [UNIT]
        _chaseTarget - Unit the zombie should target [UNIT]

    Returns:
        Nothing

    Example(s):
        [_zombie, allPlayers # 0] call vgm_g_fnc_zombie_setChaseTarget;
 */

params ["_zombie", "_chaseTarget"];

_zombie setVariable ["vgm_l_zombie_chaseTarget", _chaseTarget];
