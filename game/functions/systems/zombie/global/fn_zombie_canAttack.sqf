/*
    File: fn_zombie_canAttack.sqf
    Author: Savage Game Design
    Date: 2025-10-20
    Last Update: 2025-10-29
    Public: No

    Description:
        Can a zombie attempt an attack?

    Parameter(s):
        _zombie - Unit to use [UNIT]

    Returns:
        Can the zombie begin an attack? [BOOLEAN]

    Example(s):
        [cursorObject] call vgm_g_fnc_zombie_canAttack;
 */

params ["_zombie"];

private _nextAttackTime = _zombie getVariable ["vgm_l_zombie_nextAttackAvailableTime", 0];

_nextAttackTime < time && !(_zombie getVariable ["vgm_l_zombie_attacking", false]) && { alive _zombie && lifeState _zombie in ["HEALTHY", "INJURED"] }
