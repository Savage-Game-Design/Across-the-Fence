/*
    File: fn_skills_apply_steadyAim.sqf
    Author: Savage Game Design
    Date: 2023-05-20
    Last Update: 2023-05-20
    Public: No

    Description:
        Applies the steady aim effect to the player.

    Parameter(s):
        _player - The player to apply the steady aim to.

    Returns:
        _coef [Number] - The coefficient to apply to the weapon sway.

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
*/

params ["_player"];

private _skill = ["combatTree", "steadyAim"] call vgm_g_fnc_skills_getByPath;
private _skillTree = _skill call vgm_g_fnc_skills_getSkillTreeFromSkill;
private _skillTreePoints = [_skillTree] call vgm_g_fnc_skills_getSkillTreePoints;

private _coef = 1 - (0.01 * _skillTreePoints);

_player setCustomAimCoef _coef; // Probably should store this in the db
                                // incase we want to modify the coef with multiple skills.

_coef // result
