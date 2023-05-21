/*
    File: fn_skills_apply_athletic.sqf
    Author: Savage Game Design
    Date: 2023-05-20
    Last Update: 2023-05-21
    Public: No

    Description:
        Applies the athletic skill to the player.

    Parameter(s):
        _player - The player to apply the skill to.

    Returns:
        _coef - The coefficient of the skill.

    Example(s):
        [_player] call vgm_s_fnc_skills_apply_athletic;
 */

params ["_player"];

private _skill = ["combatTree", "athletic"] call vgm_g_fnc_skills_getByPath;
private _skillTree = _skill call vgm_g_fnc_skills_getSkillTreeFromSkill;
private _skillTreePoints = [_skillTree] call vgm_g_fnc_skills_getSkillTreePoints;

private _coef = [1 - (_skillTreePoints * 0.1), 0.1, 1] call BIS_fnc_clamp;
_player setUnitTrait ["loadCoef", _coef];

_coef // result
