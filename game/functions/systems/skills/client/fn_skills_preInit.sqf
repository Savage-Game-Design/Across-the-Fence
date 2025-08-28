/*
    File: fn_preInit.sqf
    Author: veteran29
    Date: 2022-12-16
    Last Update: 2025-08-29
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

["leveling"] call vgm_c_fnc_persistence_registerSchema;

["vgm_skills_learnt", {
    _this#0 params ["_path", "_skill"];

    player call (_skill get "codeApply");
    if (_skill get "applyOnRespawn") then {
        vgm_c_skills_applyOnRespawn set [_path, _skill]
    };
}] call para_g_fnc_event_subscribeLocal;

["vgm_skills_forgotten", {
    _this#0 params ["_path", "_skill"];

    player call (_skill get "codeUnapply");
    vgm_c_skills_applyOnRespawn deleteAt _path;
}] call para_g_fnc_event_subscribeLocal;

["skillCooldown", {
    params ["_unit", "_value"];
    _unit setVariable ["vgm_c_skills_cooldownCoef", _value max 0.5 min 1];
}] call vgm_c_fnc_coefficient_create;

[] call vgm_c_fnc_skills_active_init;

["skills", {
    !isNil {player getVariable "vgm_g_skillsData"}
}] call vgm_c_fnc_loading_addHandler;
