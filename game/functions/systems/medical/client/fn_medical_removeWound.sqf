#include "script_component.inc"
/*
    File: fn_medical_removeWound.sqf
    Author: Savage Game Design
    Date: 2023-06-28
    Last Update: 2023-07-23
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
private _woundIntensity = _unit getVariable [_varDamage, 0];

_woundIntensity = (_woundIntensity - _removeWoundIntensity) max 0;

_unit setVariable [_varDamage, _woundIntensity, true];

if (lifeState _unit == "INCAPACITATED") then {
    private _severelyWounded = WOUND_MAX in (BODY_PARTS_ARR apply {[_unit, _x] call vgm_c_fnc_medical_getWound});
    if (!_severelyWounded) then {
        _unit setUnconscious false;
    };
};

if (!(_unit call vgm_c_fnc_medical_shouldBleed)) then {
    [_unit, "bleeding", "medical"] call vgm_c_fnc_statusEffect_remove;
};

// this part needs refactoring
call {
    if (_woundIntensity < 1) then {
        switch (_bodyPart) do {
            case BODY_PART_HEAD: {
                // minor blur

                // dice roll if unconscious
            };
            case BODY_PART_TORSO: {
                // a bit reduced stamina
            };
            case BODY_PART_ARMS: {
                // increased recoil
            };
            case BODY_PART_LEGS: {
                [_unit, "forceJog", "medical"] call vgm_c_fnc_statusEffect_remove;
            };
        };
    };

    if (_woundIntensity < 2) then {
        switch (_bodyPart) do {
            case BODY_PART_HEAD: {
                // medium blur
            };
            case BODY_PART_TORSO: {
                // strongly reduced stamina

                // dice roll if unconscious
            };
            case BODY_PART_ARMS: {
                // increased aim sway
                // reduced throw distance
                // a bit slower actions
            };
            case BODY_PART_LEGS: {
                [_unit, "forceWalk", "medical"] call vgm_c_fnc_statusEffect_remove;
            };
        };
    };

    if (_woundIntensity < WOUND_MAX) then {
        switch (_bodyPart) do {
            case BODY_PART_HEAD;
            case BODY_PART_TORSO: {};
            case BODY_PART_ARMS: {
                // even more increased aim sway
                // even more increased recoil
                // even more reduced throw distance
                // a lot slower actions
                // block ADS
            };
            case BODY_PART_LEGS: {
                // force prone
            };
        };
    };
};
