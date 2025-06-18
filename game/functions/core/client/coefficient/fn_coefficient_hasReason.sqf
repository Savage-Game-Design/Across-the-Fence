/*
    File: fn_coefficient_hasReason.sqf
    Author: Savage Game Design
    Date: 2025-06-18
    Last Update: 2025-06-18
    Public: Yes

    Description:
        Checks if a coefficient is set for a particular reason.

    Parameter(s):
        _unit - Unit to check the coefficient on [OBJECT]
        _coefficient - Coefficient name [STRING]
        _reason - Coefficient reason [STRING]

    Returns:
        True if the coefficient has the given reason [BOOL]

    Example(s):
        [player, "aim", "mySkill"] call vgm_c_fnc_coefficient_hasReason;
 */

params [
    ["_unit", objNull, [objNull]],
    ["_coefficient", "", [""]],
    ["_reason", nil, [""]]
];

private _coefficientReasons = _unit getVariable ["vgm_c_coefficient_currentCoefficients", createHashMap]
                             getOrDefault [_coefficient, createHashMap];

_reason in _coefficientReasons
