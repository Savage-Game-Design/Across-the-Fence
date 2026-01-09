#include "script_component.inc"
/*
    File: fn_stamina_preInit.sqf
    Author: Savage Game Design
    Date: 2023-08-18
    Last Update: 2026-01-09
    Public: No

    Description:
        Client preInit for stamina component.
 */

if (!hasInterface) exitWith {};

vgm_stamina_animCoefCache = createHashMap;

["staminaDrain", {
    params ["_unit", "_value"];
    _unit setVariable ["vgm_c_staminaDrainCoef", _value max 0];
}] call vgm_c_fnc_coefficient_create;

// additional additive coef modifier for skills, limited to 50% reduction
["staminaDrainSkills", {
    params ["_unit", "_value"];
    _unit setVariable ["vgm_c_staminaDrainCoefSkills", -0.5 max _value min 0];
}, 0] call vgm_c_fnc_coefficient_create;
