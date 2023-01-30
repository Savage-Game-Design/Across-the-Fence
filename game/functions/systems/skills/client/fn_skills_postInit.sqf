/*
    File: fn_postInit.sqf
    Author: veteran29
    Date: 2023-01-22
    Last Update: 2023-01-30
    Public: No

    Description:
        Client postInit function for skills system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

if (!hasInterface) exitWith {};

[] call vgm_c_fnc_skills_requestSkillsData;

player addEventHandler ["Respawn", {
    params ["_player"];
    {
        _player call (_y get "codeApply")
    } forEach vgm_c_skills_applyOnRespawn;
}];

// dev action, uses path instead of function so there's no need for recompiling
_fnc_addActionSkillMenu = {
    _this addAction ["Open skills menu", {
        call compileScript ["functions\systems\skills\client\fn_skills_openSkillTree.sqf"];
    }, nil, -1e10, true, false, "", "_originalTarget == _this"];
};

player call _fnc_addActionSkillMenu;
player addEventHandler ["Respawn", _fnc_addActionSkillMenu];
