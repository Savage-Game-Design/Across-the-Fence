#include "script_component.inc"
/*
    File: fn_medical_addWound.sqf
    Author: Savage Game Design
    Date: 2023-06-28
    Last Update: 2023-07-06
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

// this part needs refactoring
call {
    if (_woundIntensity >= 1) then {
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
                // strongly reduced stamina

                // dice roll if unconscious
            };
            case BODY_PART_ARMS: {
                // increased aim sway
                // reduced throw distance
                // a bit slower actions
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
                _unit setUnconscious true;
                // [_unit, false, true] remoteExec ["vn_fnc_revive_actions_local", 0, true];
            };
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

