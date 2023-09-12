/*
    File: fn_medical_setStructuralDamage.sqf
    Author: Savage Game Design
    Date: 2023-09-01
    Last Update: 2023-09-02
    Public: No

    Description:
        Sets structural damage of the unit without changing individual hitpoints.

    Parameter(s):
        _unit - Unit to set the damage for [OBJECT]
        _damage - Amount of structural damage to set [NUMBER]

    Returns:
        Nothing

    Example(s):
        [player, 0.5] call vgm_c_fnc_medical_setStructuralDamage
 */

params ["_unit", "_damage"];

private _previousHitPointsDamage = getAllHitPointsDamage _unit param [2, []];

_unit setDamage _damage;

{
    _unit setHitIndex [_forEachIndex, _x];
} forEach _previousHitPointsDamage;
