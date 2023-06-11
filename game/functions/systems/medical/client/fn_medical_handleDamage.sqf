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

#define COEF_FRIENDLY_FIRE 0.25
#define KNOCKED_OUT_GRACE_TIME 1

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

/*
// Drowning applies constant stuctural damage in fixed increments
if (
    _hitPoint isEqualTo "#structural" &&
    {getOxygenRemaining _unit <= 0.5} &&
    {_damage isEqualTo (_currentDamage + 0.005)}
) then {
};
*/

// decrease amount of damage taken due to friendly fire
if (
    !isNull _instigator && {
    _instigator isNotEqualTo _unit && {
    (side group _unit) isEqualTo (side group _instigator)}
}) then {
    _hitDamage = _hitDamage * COEF_FRIENDLY_FIRE;
};

private _downed = lifeState _unit == "INCAPACITATED";
// prevent unit from being killed immedatiely after being knocked out
if (
    _downed
    && {time < (_unit getVariable ["vgm_c_knockedOutGraceTime", -1])}
) exitWith {
    _currentDamage // return
};

private _newDamage = _currentDamage + _hitDamage;
// knock out the unit
if (_newDamage >= 1 && !_downed) exitWith {
    _unit setVariable ["vgm_c_knockedOutGraceTime", time + KNOCKED_OUT_GRACE_TIME];
    _unit setUnconscious true;
    0.99 // return
};

// private _source = [_source, _instigator] select isNull _source;

_newDamage // return
