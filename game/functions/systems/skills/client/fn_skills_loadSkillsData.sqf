/*
    File: fn_skills_loadSkills.sqf
    Author:
    Date: 2023-01-21
    Last Update: 2023-01-22
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

params ["_skillsData"];

["DEBUG", format ["VGM: Loading skills data '%1'", _skillsData]] call para_g_fnc_log;

{
    private _skill = _x call vgm_g_fnc_skills_getSkillByPath;
    [_skill, false] call vgm_c_fnc_skills_learn;
} forEach (_skillsData get "skillPaths");

vgm_skills_points = _skillsData get "skillPoints";
