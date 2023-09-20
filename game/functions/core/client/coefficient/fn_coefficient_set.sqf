/*
    File: fn_coefficient_set.sqf
    Author: Savage Game Design
    Date: 2023-08-21
    Last Update: 2023-09-20
    Public: Yes

    Description:
        Set coefficient reason/value on an unit.

    Parameter(s):
        _unit - Unit to set the coefficient on [OBJECT]
        _coefficient - Coefficient name [STRING]
        _reason - Coefficient reason [STRING]
        _value - Coefficient value, will be added to "base" value of the coefficient [NUMBER, defaults to 0]
        _persistent - Should the reason/value be re-applied upon respawn [BOOL, defaults to false]

    Returns:
        Calculated coefficient value [NUMBER]

    Example(s):
        [player, "aim", "stamina", 2] call vgm_c_fnc_coefficient_set
        [player, "aim", "skills", -0.15, true] call vgm_c_fnc_coefficient_set
 */

params [
    ["_unit", objNull, [objNull]],
    ["_coefficient", "", [""]],
    ["_reason", nil, [""]],
    ["_value", 0, [0]],
    ["_persistent", false, [true]]
];


if (!(_coefficient in vgm_c_coefficient_allCoefficients)) exitWith {
    format ["Invalid coefficient, available values: %1", keys vgm_c_coefficient_allCoefficients] call vgm_g_fnc_logError;
};

private _coefficientMap = _unit getVariable "vgm_c_coefficient_currentCoefficients";
if (isNil "_coefficientMap") then {
    format ["Creating current coefficients map: %1", _unit] call vgm_g_fnc_logDebug;

    _coefficientMap = createHashMap;
    _unit setVariable ["vgm_c_coefficient_currentCoefficients", _coefficientMap];
    // clear all non persistent coefficients upon respawn
    _unit addEventHandler ["Respawn", {
        params ["_unit"];
        {
            private _coefficient = _x;
            {
                private _reason = _x;
                private _coefficientValues = _y;
                // ignore persistent coefficients
                if (_coefficientValues # 1) then {continue};
                [_unit, _coefficient, _reason] call vgm_c_fnc_coefficient_remove;
            } forEach _y;
            // re-apply persistent coefficient values, needed in case "remove" was not called at least once
            [_unit, _coefficient, nil] call vgm_c_fnc_coefficient_set;
        } forEach (_unit getVariable "vgm_c_coefficient_currentCoefficients");
    }]
};
// set a reason if there's one, onChange function will always be applied
if (!isNil "_reason") then {
    format ["Setting coefficient reason: %1 | %2 | %3 | %4", _coefficient, _reason, _value, _persistent] call vgm_g_fnc_logInfo;

    private _coefficientValues = _coefficientMap getOrDefault [_coefficient, createHashMap, true];

    if (_value isEqualTo 0) exitWith {
        _coefficientValues deleteAt _reason;
    };

    _coefficientValues set [_reason, [_value, _persistent]];
};

private _calculatedValue = [_unit, _coefficient] call vgm_c_fnc_coefficient_get;

[_unit, _calculatedValue] call (vgm_c_coefficient_allCoefficients get _coefficient get "onChange");

_calculatedValue // return
