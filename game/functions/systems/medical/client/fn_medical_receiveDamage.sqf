#include "script_component.inc"
/*
    File: fn_medical_receiveDamage.sqf
    Author: Savage Game Design
    Date: 2023-06-17
    Last Update: 2023-06-27
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [parameter] call vgm_c_fnc_medical_receiveDamage
 */

params ["_unit", "_damage", "_hitPoint", "_source", "_projectile", "_directHit"];

private _bodyPart = vgm_c_medical_hitPointBodyPartMap get _hitPoint;

if (isNil "_bodyPart") exitWith {
    format ["(Medical) Invalid HitPoint: %1", _hitPoint] call vgm_g_fnc_logError;
};

private _normalizedDamage = _damage * getNumber (configOf _unit >> "HitPoints" >> _hitPoint >> "armor");

private _damageLevel = switch (_bodyPart) do {
    case BODY_PART_HEAD;
    case BODY_PART_TORSO;
    case BODY_PART_LEGS: {
        if (_normalizedDamage > 8) exitWith {3};
        // threshold of 4 gives us 2 "hit levels" for most rifles at smaller ranges
        if (_normalizedDamage > 4) exitWith {2};
        1
    };
    case BODY_PART_ARMS: {
        if (_normalizedDamage > 6) exitWith {3};
        if (_normalizedDamage > 3) exitWith {2};
        1
    };
    default {
        format ["(Medical) Invalid BodyPart: %1", _bodyPart] call vgm_g_fnc_logError;
        1
    };
};

format ["(%6) Receive damage: %1 | %2 | %3 | %4 | %5", _normalizedDamage, _damageLevel, _bodyPart, _hitPoint, _projectile, diag_frameNo] call vgm_g_fnc_logInfo;

private _varDamage = format ["vgm_c_medical_damage$%1", _bodyPart];
private _currentDamageLevel = _unit getVariable [_varDamage, 0];
