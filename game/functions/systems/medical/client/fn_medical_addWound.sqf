#include "script_component.inc"
/*
    File: fn_medical_addWound.sqf
    Author: Savage Game Design
    Date: 2023-06-28
    Last Update: 2025-10-22
    Public: No

    Description:
        Add wound to the specified body part.

    Parameter(s):
        _unit - Unit to add the wound to [OBJECT]
        _bodyPart - Target body part [STRING]
        _addWoundIntensity - How many levels of intensity to add [NUMBER]

    Returns:
        Nothing

    Example(s):
        [_unit, "torso", 2] call vgm_c_fnc_medical_addWound;
 */

params ["_unit", "_bodyPart", "_addWoundIntensity"];

if (!isDamageAllowed _unit || _addWoundIntensity < 1) exitWith {};

private _varDamage = format ["vgm_g_medical_wound$%1", _bodyPart];
private _previousWoundIntensity = _unit getVariable [_varDamage, WOUND_NONE];

private _woundIntensity = (_previousWoundIntensity + _addWoundIntensity) min WOUND_MAX;

_unit setVariable [_varDamage, _woundIntensity, true];

if (_unit call vgm_c_fnc_medical_shouldBleed) then {
    [_unit, "bleeding", "medical"] call vgm_c_fnc_statusEffect_set;
};

[_unit, _bodyPart, _woundIntensity > WOUND_NONE] call vgm_c_fnc_medical_updateVisuals;
[_unit, _bodyPart, _previousWoundIntensity, _woundIntensity] call vgm_c_fnc_medical_injuryEffectsUpdate;

["vgm_medical_woundAdded", _this] call para_g_fnc_event_triggerLocal;
