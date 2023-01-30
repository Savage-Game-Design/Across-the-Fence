/*
    File: fn_preInit.sqf
    Author: veteran29
    Date: 2022-12-16
    Last Update: 2023-01-30
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

["vgm_skills_learnt", {
    _this#0 params ["_path", "_skill"];

    player call (_skill get "codeApply");
    if (_skill get "applyOnRespawn") then {
        vgm_c_skills_applyOnRespawn set [_path, _skill]
    };
}] call para_g_fnc_event_subscribeLocal;
