#include "script_component.inc"
/*
    File: fn_medical_addWound.sqf
    Author: Savage Game Design
    Date: 2023-06-28
    Last Update: 2023-08-27
    Public: No

    Description:
        Add wound to the specified body part.

    Parameter(s):
        _unit - Unit to add the wound to [OBJECT]
        _bodyPart - Target body part [STRING]
        _removeWoundIntensity - How many levels of intensity to add [NUMBER]

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

if (_unit call vgm_c_fnc_medical_shouldBleed) then {
    [_unit, "bleeding", "medical"] call vgm_c_fnc_statusEffect_set;
};

["vgm_medical_woundAdded", _this] call para_g_fnc_event_triggerLocal;

// this part needs refactoring
call {
    if (_woundIntensity >= 1) then {
        switch (_bodyPart) do {
            case BODY_PART_HEAD: {
                // minor blur

                // dice roll if unconscious
            };
            case BODY_PART_TORSO: {
                [_unit, "staminaDrain", "medical", DEBUFF_STAMINA_MINOR] call vgm_c_fnc_coefficient_set;
            };
            case BODY_PART_ARMS: {
                [_unit, "recoil", "medical", DEBUFF_RECOIL_MINOR] call vgm_c_fnc_coefficient_set;
            };
            case BODY_PART_LEGS: {
                [_unit, "forceJog", "medical"] call vgm_c_fnc_statusEffect_set;
            };
        };
    };

    if (_woundIntensity >= 2) then {
        switch (_bodyPart) do {
            case BODY_PART_HEAD: {
                // medium blur
            };
            case BODY_PART_TORSO: {
                [_unit, "staminaDrain", "medical", DEBUFF_STAMINA_MAJOR] call vgm_c_fnc_coefficient_set;

                // dice roll if unconscious
            };
            case BODY_PART_ARMS: {
                [_unit, "aim", "medical", DEBUFF_AIM_MINOR] call vgm_c_fnc_coefficient_set;
                [_unit, "throw", "medical", DEBUFF_THROW_MINOR] call vgm_c_fnc_coefficient_set;
                [_unit, "interact", "medical", DEBUFF_INTERACT_MINOR] call vgm_c_fnc_coefficient_set;
            };
            case BODY_PART_LEGS: {
                [_unit, "forceWalk", "medical"] call vgm_c_fnc_statusEffect_set;
            };
        };
    };

    if (_woundIntensity >= WOUND_MAX) then {
        switch (_bodyPart) do {
            case BODY_PART_HEAD;
            case BODY_PART_TORSO: {
                if (lifeState _unit == "INCAPACITATED") exitWith {};
                _unit call vgm_c_fnc_medical_setUnconscious;
            };
            case BODY_PART_ARMS: {
                [_unit, "recoil", "medical", DEBUFF_RECOIL_MAJOR] call vgm_c_fnc_coefficient_set;
                [_unit, "aim", "medical", DEBUFF_AIM_MAJOR] call vgm_c_fnc_coefficient_set;
                [_unit, "throw", "medical", DEBUFF_THROW_MAJOR] call vgm_c_fnc_coefficient_set;
                [_unit, "interact", "medical", DEBUFF_INTERACT_MAJOR] call vgm_c_fnc_coefficient_set;

                [_unit , "blockADS", "medical"] call vgm_c_fnc_statusEffect_set;
            };
            case BODY_PART_LEGS: {
                [_unit, "forceCrawl", "medical"] call vgm_c_fnc_statusEffect_set;
            };
        };
    };
};
