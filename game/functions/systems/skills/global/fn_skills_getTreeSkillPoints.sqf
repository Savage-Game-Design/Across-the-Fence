/*
    File: fn_skills_getTreeSkillPoints.sqf
    Author: Savage Game Design
    Date: 2023-05-13
    Last Update: 2025-10-11
    Public: No

    Description:
        Get amount of skill points player invested into the skilltree.

    Parameter(s):
        _skillTree - The skilltree to get the skill points from [STRING]
        _player - Player to check [OBJECT, defaults to player]

    Returns:
        Amount of skillpoints [NUMBER]

    Example(s):
        [_tree, player] call vgm_g_fnc_skills_getTreeSkillPoints;
 */

params ["_skillTree", ["_player", player]];

[_skillTree, _player, 1e10] call vgm_g_fnc_skills_getTreeSkillPointsBelowTier;
