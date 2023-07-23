#include "script_component.inc"
/*
    File: fn_medical_receiveDamage.sqf
    Author: Savage Game Design
    Date: 2023-06-17
    Last Update: 2023-07-23
    Public: No

    Description:
        Receive damage after it was processed by HandleDamage,
        normalize it for wound intensity calculation and apply damage modifiers.

    Parameter(s):
        _unit - Unit receiving the damage [OBJECT]
        _damage - Damage amount [NUMBER]
        _hitPoint - Hit point name [STRING]
        _source - Source of the damage [OBJECT]
        _projectile - Classname of the ammo causing the damage [STRING]
        _directHit - Is the damage a direct hit [BOOL]

    Returns:
        Nothing

    Example(s):
        [player, 2, "hitchest", player, "vn_762x33", true] call vgm_c_fnc_medical_receiveDamage
 */

params ["_unit", "_damage", "_hitPoint", "_source", "_projectile", "_directHit"];

private _bodyPart = vgm_c_medical_hitPointBodyPartMap get _hitPoint;

if (isNil "_bodyPart") exitWith {
    format ["(Medical) Invalid HitPoint: %1", _hitPoint] call vgm_g_fnc_logWarning;
};

private _normalizedDamage = _damage * getNumber (configOf _unit >> "HitPoints" >> _hitPoint >> "armor");

private _woundIntensity = switch (_bodyPart) do {
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

format ["(%6) Receive damage: %1 | %2 | %3 | %4 | %5", _normalizedDamage, _woundIntensity, _bodyPart, _hitPoint, _projectile, diag_frameNo] call vgm_g_fnc_logInfo;


private _damageParams = [_unit, _bodyPart, _woundIntensity];

{
    private _stopExecution = _damageParams call {
        private ["_damageParams"];
        _this call _x
    };

    if (true isEqualTo _stopExecution) exitWith {};
} forEach vgm_c_medical_damageModifiers;

_damageParams call vgm_c_fnc_medical_addWound;
