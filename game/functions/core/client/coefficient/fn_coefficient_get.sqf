/*
    File: fn_coefficient_get.sqf
    Author: Savage Game Design
    Date: 2023-08-21
    Last Update: 2024-11-12
    Public: Yes

    Description:
        Get calculated coefficient value from an unit.

    Parameter(s):
        _unit - Unit to get the coefficient value from [OBJECT]
        _coefficient - Coefficient name [STRING]

    Returns:
        Calculated coefficient value [NUMBER]

    Example(s):
        [player, "aim"] call vgm_c_fnc_coefficient_get
 */

params [
    ["_unit", objNull, [objNull]],
    ["_coefficient", "", [""]]
];

private _coefficientMap = _unit getVariable ["vgm_c_coefficient_currentCoefficients", createHashMap];

private _calculatedValue = vgm_c_coefficient_allCoefficients get _coefficient get "baseValue";
{
    _calculatedValue = _calculatedValue + _x#0;
} forEach values (_coefficientMap getOrDefault [_coefficient, createHashMap]);

_calculatedValue // return
