/*
    File: fn_preInit.sqf
    Author: veteran29
    Date: 2022-12-16
    Last Update: 2023-01-26
    Public: No

    Description:
        Client preInit function for skills system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

if (!hasInterface) exitWith {};

["vgm_skills_loadData", {
    params ["_skillsData"];
    ["DEBUG", format ["VGM: Loading skills data '%1'", _skillsData]] call para_g_fnc_log;

    {
        private _skill = _x call vgm_g_fnc_skills_getSkillByPath;
        [_skill, false] call vgm_c_fnc_skills_learn;
    } forEach (_skillsData get "skillPaths");

    vgm_skills_points = _skillsData get "skillPoints";

}] call para_g_fnc_event_subscribeServer;

// TODO available skill points could be calculated in function
// eg. PLAYER_LEVEL - KNOWN_SKILLS_COST or smth.
// needs actual player level/profile API
vgm_skills_points = 0;

vgm_skills_knownSkills = createHashMap;
