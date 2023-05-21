/*
    File: fn_skills_apply_athletic.sqf
    Author: Savage Game Design
    Date: 2023-05-20
    Last Update: 2023-05-21
    Public: No

    Description:
        Applies the athletic skill to the player.

    Parameter(s):

    Returns:
        _coef - The coefficient of the skill.

    Example(s):
        call vgm_c_fnc_skills_apply_athletic;
 */

private _skill = ["combatTree", "athletic"] call vgm_g_fnc_skills_getByPath;
private _skillTree = _skill call vgm_g_fnc_skills_getSkillTreeFromSkill;
private _skillTreePoints = [_skillTree] call vgm_g_fnc_skills_getSkillTreePoints;

private _coef = (1 - _skillTreePoints * 0.1) max 0.1 min 1;
player setUnitTrait ["loadCoef", _coef];

_coef // result
