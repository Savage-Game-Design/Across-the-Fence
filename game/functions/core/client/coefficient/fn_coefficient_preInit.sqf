/*
    File: fn_coefficient_preInit.sqf
    Author: Savage Game Design
    Date: 2023-08-21
    Last Update: 2025-01-17
    Public: No

    Description:
        Coefficient client preInit.
 */

["aim", {
    params ["_unit", "_value"];
    // coef should be always greater than 0 to allow the weapon to settle on the middle of the screen
    _unit setCustomAimCoef (_value max 0.1 min 4);
}] call vgm_c_fnc_coefficient_create;

["animSpeed", {
    params ["_unit", "_value"];
    // values are limited to prevent too much jankiness
    _unit setAnimSpeedCoef (_value max 0.8 min 1.5);
}] call vgm_c_fnc_coefficient_create;

["camouflage", {
    params ["_unit", "_value"];
    _unit setUnitTrait ["camouflageCoef", _value max 0.1 min 1];
}] call vgm_c_fnc_coefficient_create;

["audible", {
    params ["_unit", "_value"];
    _unit setUnitTrait ["audibleCoef", _value max 0.1 min 1];
}] call vgm_c_fnc_coefficient_create;

["recoil", {
    params ["_unit", "_value"];
    // coef should be always greater than 0 to prevent no animation at all
    _unit setUnitRecoilCoefficient (_value max 0.25 min 4);
}] call vgm_c_fnc_coefficient_create;

["load", {
    params ["_unit", "_value"];
    // coef should be always greater than 0 to prevent infinite carry capacity
    _unit setUnitTrait ["loadCoef", _value max 0.1 min 2];
}] call vgm_c_fnc_coefficient_create;

["throw", {
    params ["_unit", "_value"];

    _unit setVariable ["vgm_c_coefficient_throw", _value max 0.1 min 2];

    if (isNil {_unit getVariable "vgm_c_coefficientThrowEh"}) then {
        format ["Adding throw coef eh to: %1", _unit] call vgm_g_fnc_logDebug;

        private _eh = _unit addEventHandler ["Fired", {
            params ["_unit", "_weapon", "", "", "", "", "_projectile"];
            if (_weapon != "Throw") exitWith {};

            private _coef = _unit getVariable ["vgm_c_coefficient_throw", 1];
            _projectile setVelocity (velocity _projectile vectorMultiply _coef);
        }];
        _unit setVariable ["vgm_c_coefficientThrowEh", _eh];
    };
}] call vgm_c_fnc_coefficient_create;

["interact", {
    params ["_unit", "_value"];
    _unit setVariable ["vgm_c_coefficient_interact", _value max 0.1 min 5];
}] call vgm_c_fnc_coefficient_create;
