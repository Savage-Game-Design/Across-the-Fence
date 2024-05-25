/*
    File: fn_coefficient_override.sqf
    Author: Savage Game Design
    Date: 2023-11-26
    Last Update: 2023-12-02
    Public: Yes

    Description:
        Set coefficient override on an unit, the coefficient callback won't apply while it's overriden.

    Parameter(s):
        _unit - Unit to set the override on [OBJECT]
        _coefficient - Coefficient name [STRING]
        _reason - Override reason [STRING]
        _override - Is overriden with given reason [BOOL, defaults to true]

    Returns:
        Is overriden [BOOL]

    Example(s):
        [_healer, "animSpeed", "medical_item", false] call vgm_c_fnc_coefficient_override;
 */

params [
    ["_unit", objNull, [objNull]],
    ["_coefficient", "", [""]],
    ["_reason", nil, [""]],
    ["_override", true, [true]]
];


if (!(_coefficient in vgm_c_coefficient_allCoefficients)) exitWith {
    format ["Invalid coefficient, available values: %1", keys vgm_c_coefficient_allCoefficients] call vgm_g_fnc_logError;
};

private _coefficientOverridesMap = _unit getVariable "vgm_c_coefficient_currentCoefficientsOverrides";
if (isNil "_coefficientOverridesMap") then {
    _coefficientOverridesMap = createHashMap;
    _unit setVariable ["vgm_c_coefficient_currentCoefficientsOverrides", _coefficientOverridesMap];
};

// not possible to override without reason
if (isNil "_reason") exitWith {
    format ["No reason given: %1 | %2", _coefficient, _override] call vgm_g_fnc_logError;
    false
};

format ["Setting coefficient override: %1 | %2 | %3", _coefficient, _reason, _override] call vgm_g_fnc_logDebug;

private _coefficientOverrides = _coefficientOverridesMap getOrDefault [_coefficient, createHashMap, true];
if (_override) then {
    _coefficientOverrides set [_reason, nil];
} else {
    _coefficientOverrides deleteAt _reason;
};

private _isOverriden = count values _coefficientOverrides > 0;

// if override is not applied anymore fire the onChange callback
if (!_isOverriden) then {
    [_unit, _coefficient, nil] call vgm_c_fnc_coefficient_set;
};

_isOverriden // return
