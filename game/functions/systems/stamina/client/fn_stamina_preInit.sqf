#include "script_component.inc"
/*
    File: fn_stamina_preInit.sqf
    Author: Savage Game Design
    Date: 2023-08-18
    Last Update: 2026-01-11
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

["vgm_stamina_adjust", {
    (_this#0) params ["_unit", ["_amount", 0]];

    format ["Adjusting stamina: %1 | %2", _unit, _amount] call vgm_g_fnc_logInfo;

    private _currentStamina = _unit getVariable ["vgm_stamina", 1];
    private _newStamina = (_currentStamina + _amount) min 100 max 0;
    _unit setVariable ["vgm_stamina", _newStamina];

}] call para_g_fnc_event_subscribe;

