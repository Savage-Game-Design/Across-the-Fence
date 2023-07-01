#include "script_component.inc"
/*
    File: fn_medical_removeWound.sqf
    Author: Savage Game Design
    Date: 2023-06-28
    Last Update: 2023-06-30
    Public: No

    Description:
        Remove wound from the specified body part.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [_unit, "torso", 1] call vgm_c_fnc_medical_removeWound;
 */

params ["_unit", "_bodyPart", "_removeWoundIntensity"];

private _varDamage = format ["vgm_g_medical_wound$%1", _bodyPart];
private _woundIntensity = _unit getVariable [_varDamage, 0];

_woundIntensity = (_woundIntensity - _removeWoundIntensity) max 0;

_unit setVariable [_varDamage, _woundIntensity, true];

if (lifeState _unit == "INCAPACITATED" && {_bodyPart in [BODY_PART_HEAD, BODY_PART_TORSO]}) then {
    private _severelyWounded = WOUND_MAX in ([BODY_PART_HEAD, BODY_PART_TORSO] apply {_unit getVariable [format ["vgm_g_medical_wound$%1", _x], 0]});
    if (!_severelyWounded) then {
        _unit setUnconscious false;
    };
};
