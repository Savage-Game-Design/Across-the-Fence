/*
    File: fn_skill_passive_increasedAccuracy.sqf
    Author: Savage Game Design
    Date: 2023-06-16
    Last Update: 2023-06-17
    Public: No

    Description:
        Applies the increased accuracy perk to the player.
        Lowers recoil by 1% per skill point in the skill tree.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        call vgm_c_fnc_skill_passive_increasedAccuracy;
 */

private _skill = ["combatTree", "increasedAccuracy"] call vgm_g_fnc_skills_getByPath;
private _skillTree = _skill call vgm_g_fnc_skills_getSkillTreeFromSkill;
private _skillTreePoints = [_skillTree] call vgm_g_fnc_skills_getTreeSkillPoints;

private _coef = (1 - 0.01 * _skillTreePoints) max 0 min 1;
player setUnitRecoilCoefficient _coef;

_coef // result
