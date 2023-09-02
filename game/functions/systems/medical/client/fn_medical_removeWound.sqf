#include "script_component.inc"
/*
    File: fn_medical_removeWound.sqf
    Author: Savage Game Design
    Date: 2023-06-28
    Last Update: 2023-09-02
    Public: Yes

    Description:
        Remove wound from the specified body part.

    Parameter(s):
        _unit - Unit to remove the wound from [OBJECT]
        _bodyPart - Target body part [STRING]
        _removeWoundIntensity - How many levels of intensity to remove [NUMBER]

    Returns:
        Something [BOOL]

    Example(s):
        [_unit, "torso", 1] call vgm_c_fnc_medical_removeWound;
 */

params ["_unit", "_bodyPart", "_removeWoundIntensity"];

private _varDamage = format ["vgm_g_medical_wound$%1", _bodyPart];
private _previousWoundIntensity = _unit getVariable [_varDamage, WOUND_NONE];

private _woundIntensity = (_previousWoundIntensity - _removeWoundIntensity) max 0;

_unit setVariable [_varDamage, _woundIntensity, true];

if (lifeState _unit == "INCAPACITATED") then {
    private _severelyWounded = WOUND_MAX in (BODY_PARTS_ARR apply {[_unit, _x] call vgm_c_fnc_medical_getWound});
    if (!_severelyWounded) then {
        [_unit, false] call vgm_c_fnc_medical_setUnconscious;
    };
};

if (!(_unit call vgm_c_fnc_medical_shouldBleed)) then {
    [_unit, "bleeding", "medical"] call vgm_c_fnc_statusEffect_remove;
};

[_unit, _bodyPart, _woundIntensity > WOUND_NONE] call vgm_c_fnc_medical_updateVisuals;
[_unit, _bodyPart, _previousWoundIntensity, _woundIntensity] call vgm_c_fnc_medical_injuryEffectsUpdate;

["vgm_medical_woundRemoved", _this] call para_g_fnc_event_triggerLocal;
