/*
    File: fn_postInit.sqf
    Author: veteran29
    Date: 2023-01-22
    Last Update: 2023-01-22
    Public: No

    Description:
        Client postInit function for skills system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

if (!hasInterface) exitWith {};

// TODO, placeholder until event system is available
// request skill data from server
[player] remoteExecCall ["vgm_s_fnc_skills_loadPlayerSkills", 2];


// dev action, uses path instead of function so there's no need for recompiling
_fnc_addActionSkillMenu = {
    _this addAction ["Open skills menu", {
        call compileScript ["functions\systems\skills\client\fn_skills_openSkillTree.sqf"];
    }, nil, -1e10];
};

player call _fnc_addActionSkillMenu;
player addEventHandler ["Respawn", _fnc_addActionSkillMenu];
