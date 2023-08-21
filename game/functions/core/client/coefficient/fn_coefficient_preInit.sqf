/*
    File: fn_coefficient_preInit.sqf
    Author: Savage Game Design
    Date: 2023-08-21
    Last Update: 2023-08-21
    Public: No

    Description:
        Coefficient client preInit.
 */

["aim", {
    params ["_unit", "_value"];
    _unit setCustomAimCoef _value;
}] call vgm_c_fnc_coefficient_create;
