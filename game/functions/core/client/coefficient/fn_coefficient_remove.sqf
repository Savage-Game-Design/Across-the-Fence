/*
    File: fn_coefficient_remove.sqf
    Author: Savage Game Design
    Date: 2023-08-21
    Last Update: 2023-08-21
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [player, "aim", "stamina", 2] call vgm_c_fnc_coefficient_remove
 */

params [
    ["_unit", objNull, [objNull]],
    ["_coefficient", "", [""]],
    ["_reason", nil, [""]]
];

if (!(_coefficient in vgm_c_coefficient_allCoefficients)) exitWith {
    format ["Invalid coefficient, available values: %1", keys vgm_c_statusEffect_allEffects] call vgm_g_fnc_logError;
};

private _coefficientMap = _unit getVariable "vgm_c_coefficient_currentCoefficients";
if (isNil "_coefficientMap") exitWith {};

format ["Removing coefficient reason: %1 | %2", _coefficient, _reason] call vgm_g_fnc_logInfo;

private _coefficientValues = _coefficientMap getOrDefault [_coefficient, [], true];

_coefficientValues deleteAt _reason;

private _calculatedValue = [_unit, _coefficient] call vgm_c_fnc_coefficient_get;

[_unit, _calculatedValue] call (vgm_c_coefficient_allCoefficients get _coefficient get "onChange");

_calculatedValue // return
