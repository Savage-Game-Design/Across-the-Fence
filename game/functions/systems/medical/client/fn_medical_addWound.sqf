#include "script_component.inc"
/*
    File: fn_medical_addWound.sqf
    Author: Savage Game Design
    Date: 2023-06-28
    Last Update: 2023-06-30
    Public: No

    Description:
        Add wound to the specified body part.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [_unit, "torso", 2] call vgm_c_fnc_medical_addWound;
 */

params ["_unit", "_bodyPart", "_addWoundIntensity"];

private _varDamage = format ["vgm_g_medical_wound$%1", _bodyPart];
private _woundIntensity = _unit getVariable [_varDamage, 0];

_woundIntensity = (_woundIntensity + _addWoundIntensity) min WOUND_MAX;

_unit setVariable [_varDamage, _woundIntensity, true];

if (_woundIntensity >= WOUND_MAX) then {
    switch (_bodyPart) do {
        case BODY_PART_HEAD;
        case BODY_PART_TORSO: {
            if (lifeState _unit == "INCAPACITATED") exitWith {};
            _unit setUnconscious true;
            // [_unit, false, true] remoteExec ["vn_fnc_revive_actions_local", 0, true];
        };
        case BODY_PART_ARMS: {

        };
        case BODY_PART_LEGS: {

        };
    };
};
