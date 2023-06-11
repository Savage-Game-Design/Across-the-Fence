/*
    File: fn_medical_handleDamage.sqf
    Author: Savage Game Design
    Date: 2023-06-11
    Last Update: 2023-06-11
    Public: No

    Description:
        Handle unit damage.

    Parameter(s):
        N/A

    Returns:
        New damage for handled HitPoint [NUMBER]

    Example(s):
        call vgm_c_fnc_medical_handleDamage
 */

params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint", "_directHit"];
if (!isDamageAllowed _unit) exitWith {};

// damage of the unit/hitpoint BEFORE currently processed damage instance
private _currentDamage = 0;
if (_hitPoint isEqualTo "") then {
    _hitPoint = "#structural";
    _currentDamage = damage _unit;
} else {
    _currentDamage = _unit getHitIndex _hitIndex;
};

private _hitDamage = _damage - _currentDamage;

systemChat str [_hitPoint, _currentDamage, _hitDamage];

// Drowning applies constant stuctural damage in fixed increments
if (
    _hitPoint isEqualTo "#structural" &&
    {getOxygenRemaining _unit <= 0.5} &&
    {_damage isEqualTo (_currentDamage + 0.005)}
) then {
    systemChat "TODO drowning";
};

private _source = [_source, _instigator] select isNull _source;

if (
    !isNull _instigator && {
    _instigator isNotEqualTo _unit && {
    (side group _unit) isEqualTo (side group _instigator)}
}) then {
    systemChat "friendly fire";
    _hitDamage = _hitDamage * 0.25;
};

private _downed = lifeState _unit == "INCAPACITATED";
if (_downed) exitWith {_currentDamage};

_currentDamage + _hitDamage // return
