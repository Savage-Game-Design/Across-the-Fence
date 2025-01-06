#include "\a3\ui_f\hpp\defineDIKCodes.inc"

/*
    File: fn_skill_investigate_postInit.sqf
    Author: Savage Game Design
    Date: 2024-01-17
    Last Update: 2025-01-06
    Public: No

    Description:
        Pre init for Skill Investigate component.
 */

if (!hasInterface) exitWith {};

vgm_c_skill_investigate_intensity = 0;

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

["ToggleFocus", vgm_c_fnc_skill_investigate_toggleFocusMode] call para_c_fnc_keyhandler_addGeneralActionHandler;
