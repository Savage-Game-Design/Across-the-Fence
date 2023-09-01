#include "script_component.inc"
/*
    File: fn_medical_removeWound.sqf
    Author: Savage Game Design
    Date: 2023-06-28
    Last Update: 2023-09-01
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
        [_unit, false] call vgm_c_fnc_medical_setUnconscious;
    };
};

if (!(_unit call vgm_c_fnc_medical_shouldBleed)) then {
    [_unit, "bleeding", "medical"] call vgm_c_fnc_statusEffect_remove;
};

["vgm_medical_woundRemoved", _this] call para_g_fnc_event_triggerLocal;

// this part needs refactoring, possibly into some sort of statemachine?
call {
    // 3 => 2
    if (_woundIntensity < WOUND_MAX) then {
        switch (_bodyPart) do {
            case BODY_PART_HEAD;
            case BODY_PART_TORSO: {};
            case BODY_PART_ARMS: {
                [_unit, "recoil", "medical", DEBUFF_AIM_MINOR] call vgm_c_fnc_coefficient_set;
                [_unit, "aim", "medical", DEBUFF_AIM_MINOR] call vgm_c_fnc_coefficient_set;
                [_unit, "throw", "medical", DEBUFF_THROW_MINOR] call vgm_c_fnc_coefficient_set;
                [_unit, "interact", "medical", DEBUFF_INTERACT_MINOR] call vgm_c_fnc_coefficient_set;

                [_unit , "blockADS", "medical"] call vgm_c_fnc_statusEffect_remove;
            };
            case BODY_PART_LEGS: {
                [_unit, "forceCrawl", "medical"] call vgm_c_fnc_statusEffect_remove;
            };
        };
    };

    // 2 => 1
    if (_woundIntensity < 2) then {
        switch (_bodyPart) do {
            case BODY_PART_HEAD: {
                [_unit, "blurryVision", "medical", DEBUFF_BLURRYVISION_MINOR] call vgm_c_fnc_coefficient_set;
            };
            case BODY_PART_TORSO: {
                [_unit, "staminaDrain", "medical", DEBUFF_STAMINA_MINOR] call vgm_c_fnc_coefficient_set;
            };
            case BODY_PART_ARMS: {
                [_unit, "aim", "medical", 0] call vgm_c_fnc_coefficient_set;
                [_unit, "throw", "medical", 0] call vgm_c_fnc_coefficient_set;
                [_unit, "interact", "medical", 0] call vgm_c_fnc_coefficient_set;
            };
            case BODY_PART_LEGS: {
                [_unit, "forceWalk", "medical"] call vgm_c_fnc_statusEffect_remove;
            };
        };
    };

    // 1 => 0
    if (_woundIntensity < 1) then {
        switch (_bodyPart) do {
            case BODY_PART_HEAD: {
                [_unit, "blurryVision", "medical", 0] call vgm_c_fnc_coefficient_set;
            };
            case BODY_PART_TORSO: {
                [_unit, "staminaDrain", "medical", 0] call vgm_c_fnc_coefficient_set;
            };
            case BODY_PART_ARMS: {
                [_unit, "recoil", "medical", 0] call vgm_c_fnc_coefficient_set;
            };
            case BODY_PART_LEGS: {
                [_unit, "forceJog", "medical"] call vgm_c_fnc_statusEffect_remove;
            };
        };
    };
};
