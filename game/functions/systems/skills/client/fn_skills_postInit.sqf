/*
    File: fn_postInit.sqf
    Author: veteran29
    Date: 2023-01-22
    Last Update: 2025-11-13
    Public: No

    Description:
        Client postInit function for skills system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

if (!hasInterface) exitWith {};

[{
    [] call vgm_c_fnc_skills_requestSkillsData;
}] call vgm_c_fnc_persistence_addHandler;

player addEventHandler ["Respawn", {
    params ["_player"];
    {
        _player call (_y get "codeApply")
    } forEach vgm_c_skills_applyOnRespawn;

    {
        private _skillHashmap = _y;
        {
            _player call (_y get "codeApplyGroup")
        } forEach _skillHashmap;
    } forEach vgm_c_skills_applyOnRespawnGroup;
}];

// dev action, uses path instead of function so there's no need for recompiling
private _fnc_addActions = {
    params ["_player"];
    _player addAction ["Open skills menu", {
        [] call compileScript ["functions\systems\skills\client\fn_skills_openSkillTree.sqf"];
    }, nil, -1e10, true, false, "", "true"];

    _player addAction ["Open assigment menu", {
        [] call compileScript ["functions\systems\skills\client\active\fn_skills_active_openAssignMenu.sqf"];
    }, nil, -1e10, true, false, "", "true"];

    _player addAction ["Respec all skills", {
        [] call compileScript ["functions\systems\skills\client\network\fn_skills_requestSkillRespec.sqf"];
    }, nil, -1e10, true, false, "", "true"];
};

vgm_skills_managers = entities "" select {_x getVariable ["vgm_skills_manager", false]};

{
    _x call _fnc_addActions;
} forEach vgm_skills_managers;
