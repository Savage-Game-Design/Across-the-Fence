#include "script_component.inc"
/*
    File: fn_medical_receiveDamage.sqf
    Author: Savage Game Design
    Date: 2023-06-17
    Last Update: 2023-06-17
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

params ["_unit", "_damage", "_hitPoint", "_source", "_projectile"];

#ifdef DEBUG
#endif

private _bodyPart = vgm_c_medical_hitPointBodyPartMap get _hitPoint;

if (isNil "_bodyPart") exitWith {
    format ["(Medical) Invalid HitPoint: %1", _hitPoint] call vgm_g_fnc_logError;
};

private _varDamage = format ["vgm_c_medical_damage$%1", _bodyPart];
private _damage = _unit getVariable [_varDamage, 0];

_unit setVariable [_varDamage, _damage];
