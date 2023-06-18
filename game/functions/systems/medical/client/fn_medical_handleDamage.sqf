#include "script_component.inc"
/*
    File: fn_medical_handleDamage.sqf
    Author: Savage Game Design
    Date: 2023-06-11
    Last Update: 2023-06-18
    Public: No

    Description:
        Handle unit damage.

    Parameter(s):
        See: https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#HandleDamage

    Returns:
        New damage for handled HitPoint [NUMBER]

    Example(s):
        _unit addEventHandler ["HandleDamage", {call vgm_c_fnc_medical_handleDamage}];
 */

params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint", "_directHit"];
// HD can rarely fire for non local units, ignore
if (!local _unit) exitWith {nil};

// damage of the unit/hitpoint BEFORE currently processed damage instance
private _currentDamage = 0;
if (_hitPoint isEqualTo "") then {
    _hitPoint = "#structural";
    _currentDamage = damage _unit;
} else {
    _currentDamage = _unit getHitIndex _hitIndex;
};

if (!isDamageAllowed _unit) exitWith {_currentDamage};

// validate damage
if (_projectile isEqualTo "" && {isNull _source}) exitWith {
    #ifdef DEBUG
    format ["(%2) Invalid damage: %1", _hitPoint, diag_frameNo] call vgm_g_fnc_logError;
    #endif
    _currentDamage
};

private _hitDamage = _damage - _currentDamage;
// filter out tiny amounts of damage
if (_hitDamage < 1e-3) exitWith {_currentDamage};

private _downed = lifeState _unit == "INCAPACITATED";
// prevent unit from being killed when downed
if (_downed) exitWith {_currentDamage};

private _armor = [_unit, _hitPoint] call vgm_c_fnc_medical_getArmorHitPoint;
private _realDamage = _hitDamage * _armor;

#ifdef DEBUG
format ["(%7) Damage: %1 | %2 | %3 | %4 | %5 | %6", _hitPoint, _hitDamage, _realDamage, _projectile, _source, _selection, diag_frameNo] call vgm_g_fnc_logInfo;
#endif

// TODO damage sorting
[_unit, _realDamage, _hitPoint, [_source, _instigator] select isNull _source, _projectile] call vgm_c_fnc_medical_receiveDamage;

// damage of these hitpoint controls visuals or engine features like limping sway etc.
// retain the values set by our other functionalities
if (_hitPoint in ["hithead", "hitbody", "hithands", "hitlegs"]) exitWith {_currentDamage};

0 // prevent engine damage handling for all other hitpoints
