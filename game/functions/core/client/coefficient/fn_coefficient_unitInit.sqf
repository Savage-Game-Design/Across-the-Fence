/*
    File: fn_coefficient_unitInit.sqf
    Author: Savage Game Design
    Date: 2023-11-26
    Last Update: 2023-11-26
    Public: No

    Description:
        Init coefficient system on an unit.

    Parameter(s):
        _unit - Unit to init [OBJECT]

    Returns:
        Coefficient map of the unit [HASHMAP]

    Example(s):
        _unit call vgm_c_fnc_coefficient_initUnit;
 */

params ["_unit"];

format ["Creating current coefficients map: %1", _unit] call vgm_g_fnc_logDebug;

private _coefficientMap = createHashMap;
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
}];

_coefficientMap // return
