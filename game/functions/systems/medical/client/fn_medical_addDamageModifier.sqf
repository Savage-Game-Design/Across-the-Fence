/*
    File: fn_medical_addDamageModifier.sqf
    Author: Savage Game Design
    Date: 2023-07-06
    Last Update: 2023-07-06
    Public: Yes

    Description:
        Add damage modifier function which can modifiy the damage params via reference.
        If the function will return "true" then the processing will stop. Modifiers are executed in the order they are added.

    Parameter(s):
        _fnc_modifier - Damage modifier function [CODE]

    Returns:
        Damage modifier was added [BOOL]

    Example(s):
        [{
            params ["_unit", "_bodyPart", "_woundIntensity"];

            if (_bodyPart in ["head", "torso"] && {random 100 > 90}) then {
                private _redirectedBodyPart = selectRandom ["arms", "legs"];
                format ["Redirecting damage: %1 | %2 | %3", _unit, _bodyPart, _redirectedBodyPart] call vgm_g_fnc_logInfo;
                _this set [1, _redirectedBodyPart];
            };
        }] call vgm_c_fnc_medical_addDamageModifier;
 */

params [["_fnc_modifier", nil, [{}]]];

if (isNil "_fnc_modifier") exitWith {false};

vgm_c_medical_damageModifiers pushBack _fnc_modifier;

true // return
