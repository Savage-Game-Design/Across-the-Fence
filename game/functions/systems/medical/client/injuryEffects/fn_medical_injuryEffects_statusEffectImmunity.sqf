#include "script_component.inc"
/*
    File: fn_medical_injuryEffect_statusEffectImmunity.sqf
    Author: Savage Game Design
    Date: 2026-01-14
    Last Update: 2026-01-14
    Public: No

    Description:
        Status effect to manage immunity to injury effects.

    Parameter(s):
        _unit - Unit to set the immunity on [OBJECT]
        _inEffect - Whether the unit is immune to injury effects [BOOL]

    Returns:
        Nothing

    Example(s):
        [player, true] call vgm_c_fnc_medical_injuryEffects_statusEffectImmunity;
 */

params ["_unit", "_inEffect"];

format ["Injury effect immunity: %1 | %2", _unit, _inEffect] call vgm_g_fnc_logDebug;

// immediately remove all injury effects
if (_inEffect) exitWith {
    private _to = WOUND_NONE;
    {
        private _from = [_unit, _x] call vgm_c_fnc_medical_getWound;
        [_unit, _x, _from, _to] call vgm_c_fnc_medical_injuryEffectsUpdate;
    } forEach BODY_PARTS_ARR;

    _unit setVariable ["vgm_c_medical_injuryEffectImmune", true];
};

// restore all injury effects
_unit setVariable ["vgm_c_medical_injuryEffectImmune", false];
private _from = WOUND_NONE;
{
    private _to = [_unit, _x] call vgm_c_fnc_medical_getWound;
    [_unit, _x, _from, _to] call vgm_c_fnc_medical_injuryEffectsUpdate;
} forEach BODY_PARTS_ARR;
