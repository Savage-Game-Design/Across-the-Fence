/*
    File: fn_skill_passive_steadyAim.sqf
    Author: Savage Game Design
    Date: 2023-05-20
    Last Update: 2023-06-16
    Public: No

    Description:
        Applies the steady aim effect to the player.

    Parameter(s):

    Returns:
        _coef [Number] - The coefficient to apply to the weapon sway.

    Example(s):
        call vgm_c_fnc_skill_steadyAim;
*/

private _skill = ["combatTree", "steadyAim"] call vgm_g_fnc_skills_getByPath;
private _skillTree = _skill call vgm_g_fnc_skills_getSkillTreeFromSkill;
private _skillTreePoints = [_skillTree] call vgm_g_fnc_skills_getTreeSkillPoints;

private _coef = (1 - 0.01 * _skillTreePoints) max 0 min 1;
player setCustomAimCoef _coef;

_coef // result
