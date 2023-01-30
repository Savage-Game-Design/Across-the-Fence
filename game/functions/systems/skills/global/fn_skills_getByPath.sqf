/*
    File: fn_skills_getSkillByPath.sqf
    Author: veteran29
    Date: 2023-01-27
    Last Update: 2023-01-30
    Public: No

    Description:
        Get Skill or SkillTree by path.

    Parameter(s):
        _this - Path array [ARRAY]

    Returns:
        Skill or SkillTree [HashMap]

    Example(s):
        [_path] call vgm_g_fnc_skills_getByPath
        _path call vgm_g_fnc_skills_getByPath
 */

if (_this#0 isEqualType []) then {
    _this = _this#0;
};

vgm_skills_pathsHash get _this;
