#include "\a3\ui_f\hpp\defineDikCodes.inc"

/*
    File: fn_skills_active_preInit.sqf
    Author: Savage Game Design
    Date: 2023-01-28
    Last Update: 2025-06-25
    Public: No

    Description:
        Initialize active skills framework.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skills_active_init
 */

vgm_c_skills_active_list = createHashMap;

private _fnc_createSlot = {
    [_this, createHashMapFromArray [
        ["name", _this],
        ["cooldownUntil", 0],
        ["skill", createHashMap]
    ]]
};

vgm_c_skills_active_slots = createHashMapFromArray [
    "ability1" call _fnc_createSlot,
    "ability2" call _fnc_createSlot
];

["vgm_skills_learnt", {
    _this#0 params ["_path", "_skill"];
    if (!(_skill get "isActive")) exitWith {};

    vgm_c_skills_active_list set [_path, _skill];

    private _slotNames = ["ability1", "ability2"];
    private _slotIndex = _slotNames findIf { vgm_c_skills_active_slots get _x get "skill" isNotEqualTo createHashMap };
    if (_slotIndex < 0) exitWith {};
    [_slotNames # _slotIndex, _skill] call vgm_c_fnc_skills_active_assignSkillToSlot;

}] call para_g_fnc_event_subscribeLocal;

["vgm_skills_forgotten", {
    _this#0 params ["_path", "_skill"];

    vgm_c_skills_active_list deleteAt _path;

    // remove the skill from ability slot if it's not known anymore
    {
        if (_y get "skill" isEqualTo _skill) then {
            [_x, nil] call vgm_c_fnc_skills_active_assignSkillToSlot;
        };
    } forEach vgm_c_skills_active_slots;

}] call para_g_fnc_event_subscribeLocal;

// Register "OpenActiveSkillWheel" keybinding action
[
    createHashMapFromArray [
        ["name", "OpenActiveSkillWheel"],
        ["displayName", "STR_VGM_SKILLS_UI_OPEN_SKILL_WHEEL"],
        ["onRelease", false],
        ["defaultKey", createHashMapFromArray [
            ["dikCode", DIK_GRAVE]
        ]]
    ]
] call para_c_fnc_keyhandler_registerAction;

// Toggle the skill wheel when the "OpenActiveSkillWheel" action fires.
["OpenActiveSkillWheel", {
    // the keybind creates its own display which can cause issues if topmost display is not the "mission display"
    if (dialog || {!isNull (uiNamespace getVariable "RscDisplayArsenal")}) exitWith {};

    // Close skill wheel if pressed when already open.
    private _existingWheelMenu = uiNamespace getVariable ["vn_wheelmenu", displayNull];
    if !(isNull _existingWheelMenu) exitWith {
        _existingWheelMenu closeDisplay 1;
    };

    [] call vgm_c_fnc_skills_active_openSkillWheel;
}] call para_c_fnc_keyhandler_addGeneralActionHandler;


// close skills menu when unconscious
["vgm_medical_unconscious", {
    (_this#0) params ["_unit", "_state"];
    if (!_state || (_unit != player)) exitWith {};

    (uiNamespace getVariable ["vn_wheelmenu", displayNull]) closeDisplay 1;
}] call para_g_fnc_event_subscribeLocal;

[] spawn VGM_C_fnc_skills_active_toggleHud;
