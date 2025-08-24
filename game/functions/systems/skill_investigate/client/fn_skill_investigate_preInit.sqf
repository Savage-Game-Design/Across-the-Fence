#include "\a3\ui_f\hpp\defineDIKCodes.inc"

/*
    File: fn_skill_investigate_postInit.sqf
    Author: Savage Game Design
    Date: 2024-01-17
    Last Update: 2025-08-24
    Public: No

    Description:
        Pre init for Skill Investigate component.
 */

if (!hasInterface) exitWith {};

vgm_c_skill_investigate_intensity = 0;
vgm_c_skill_investigate_isFocusing = false;
vgm_c_skill_investigate_focusDelay = 3;

[
    createHashMapFromArray [
        ["name", "ToggleFocus"],
        ["displayName", "STR_VGM_SKILL_INVESTIGATE_ACTION"],
        ["onRelease", false],
        ["defaultKey", createHashMapFromArray [
            ["dikCode", DIK_T]
        ]]
    ]
] call para_c_fnc_keyhandler_registerAction;

["canFireWhileInvestigating", {
    params ["_unit", "_inEffect"];

    _unit setVariable ["vgm_c_skill_investigate_canFireWhileInvestigating", _inEffect];
}] call vgm_c_fnc_statusEffect_create;

["investigateTimeCoef", {
    params ["_unit", "_value"];
    _unit setVariable ["vgm_c_skill_investigate_investigateTimeCoef", _value max 0];
}] call vgm_c_fnc_coefficient_create;

["investigateRangeMultiplier", {
    params ["_unit", "_value"];
   _unit setVariable ["vgm_c_skill_investigate_rangeMultiplier", _value max 0.1];
}] call vgm_c_fnc_coefficient_create;

["ToggleFocus", vgm_c_fnc_skill_investigate_toggleFocusMode] call para_c_fnc_keyhandler_addGeneralActionHandler;
