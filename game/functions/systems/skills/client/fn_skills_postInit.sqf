/*
    File: fn_postInit.sqf
    Author: veteran29
    Date: 2023-01-22
    Last Update: 2023-11-10
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
private _fnc_addActions = {
    params ["_player"];
    _player addAction ["Open skills menu", {
        call compileScript ["functions\systems\skills\client\fn_skills_openSkillTree.sqf"];
    }, nil, -1e10, true, false, "", "_originalTarget == _this"];

    _player addAction ["Open assigment menu", {
        call compileScript ["functions\systems\skills\client\active\fn_skills_active_openAssignMenu.sqf"];
    }, nil, -1e10, true, false, "", "_originalTarget == _this"];

    _player addAction ["Respec all skills", {
        call compileScript ["functions\systems\skills\client\network\fn_skills_requestSkillRespec.sqf"];
    }, nil, -1e10, true, false, "", "_originalTarget == _this"];


};

vgm_core_lobbyOfficer call _fnc_addActions;
