/*
    File: fn_preInit.sqf
    Author: veteran29
    Date: 2022-12-16
    Last Update: 2023-02-25
    Public: No

    Description:
        Client preInit function for skills system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

if (!hasInterface) exitWith {};

vgm_c_skills_applyOnRespawn = createHashMap;
vgm_c_skills_appliedSkillsPaths = [];

["vgm_skills_learnt", {
    _this#0 params ["_path", "_skill"];

    player call (_skill get "codeApply");
    if (_skill get "applyOnRespawn") then {
        vgm_c_skills_applyOnRespawn set [_path, _skill]
    };

    // reapply all passive skills
    private _skillsData = player getVariable ["vgm_g_skillsData", []];
    private _skills = _skillsData get "skillPaths";

    {
        private _skill = _x call vgm_g_fnc_skills_getByPath;

        if (!(_skill get "isActive")) then {
            player call (_skill get "codeApply");
        };
    } forEach _skills;
}] call para_g_fnc_event_subscribeLocal;

["vgm_skills_forgotten", {
    _this#0 params ["_path", "_skill"];

    player call (_skill get "codeUnapply");
    vgm_c_skills_applyOnRespawn deleteAt _path;
}] call para_g_fnc_event_subscribeLocal;

[] call vgm_c_fnc_skills_active_init;
