/*
    File: fn_skills_active_preInit.sqf
    Author:
    Date: 2023-01-28
    Last Update: 2023-02-01
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

vgm_c_skills_active_list = createHashMap;

private _fnc_createSlot = {
    createHashMapFromArray [
        ["cooldown", 0],
        ["skill", createHashMap]
    ]
};

vgm_c_skills_active_slots = createHashMapFromArray [
    ["ability1", call _fnc_createSlot],
    // ["ability2", call _fnc_createSlot],
    ["ultimate", call _fnc_createSlot]
];

["vgm_skills_learnt", {
    _this#0 params ["_path", "_skill"];
    if (!(_skill get "isActive")) exitWith {};

    vgm_c_skills_active_list set [_path, _skill];

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
