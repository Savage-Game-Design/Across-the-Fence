/*
    File: fn_skills_active_preInit.sqf
    Author: Savage Game Design
    Date: 2023-01-28
    Last Update: 2023-05-13
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
    "ultimate" call _fnc_createSlot
];

["vgm_skills_learnt", {
    _this#0 params ["_path", "_skill"];
    if (!(_skill get "isActive")) exitWith {};

    vgm_c_skills_active_list set [_path, _skill];

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

// intercept select all units in group bind for skill wheel
// (grave/tilde `/~ by default)
addUserActionEventHandler ["selectAll", "Activate", {
    [] spawn {
        private _timeout = time + 1;
        waitUntil {commandingMenu != "" || time > _timeout};
        showCommandingMenu "";
    };

    [] call vgm_c_fnc_skills_active_openSkillWheel;
}];

[] spawn VGM_C_fnc_skills_active_toggleHud;
