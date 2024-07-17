/*
    File: fn_suppression_updateEffects.sqf
    Author: Savage Game Design
    Date: 2024-02-09
    Last Update: 2024-02-10
    Public: No

    Description:
        Updates the impact of suppression on a unit.

    Parameter(s):
        _unit - Unit to apply effects to [OBJECT]
        _suppressionValue - How much suppression to apply [AMOUNT]

    Returns:
        Nothing

    Example(s):
        [_unit, 0.2] call vgm_g_fnc_suppression_updateEffects;
 */

params ["_unit", "_suppressionValue"];

if !(_unit getVariable ["vgm_l_suppression_init", false]) then {
    _unit setVariable ["vgm_l_suppression_init", true];
    _unit setVariable ["vgm_l_suppression_baseAimingAccuracy", _unit skill "aimingAccuracy"];
    _unit setVariable ["vgm_l_suppression_baseAimingShake", _unit skill "aimingShake"];
};

private _newAccuracy = linearConversion [0, 1, _suppressionValue, (_unit getVariable "vgm_l_suppression_baseAimingAccuracy"), 0, true];
_unit setSkill ["aimingAccuracy", _newAccuracy];

private _newShake = linearConversion [0, 1, _suppressionValue, (_unit getVariable "vgm_l_suppression_baseAimingShake"), 0, true];
_unit setSkill ["aimingShake", _newShake];

// Suppression debug logger
//hint format ["%1 - S: %2 - A: %3 - AS: %4", _unit, _suppressionValue, _newAccuracy, _newShake];
