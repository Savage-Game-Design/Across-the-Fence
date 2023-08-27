/*
    File: fn_coefficient_preInit.sqf
    Author: Savage Game Design
    Date: 2023-08-21
    Last Update: 2023-08-27
    Public: No

    Description:
        Coefficient client preInit.
 */

["aim", {
    params ["_unit", "_value"];
    // coef should be always greater than 0 to allow the weapon to settle on the middle of the screen
    _unit setCustomAimCoef (_value max 0.1 min 4);
}] call vgm_c_fnc_coefficient_create;

["recoil", {
    params ["_unit", "_value"];
    // coef should be always greater than 0 to prevent no animation at all
    _unit setUnitRecoilCoefficient (_value max 0.25 min 4);
}] call vgm_c_fnc_coefficient_create;
