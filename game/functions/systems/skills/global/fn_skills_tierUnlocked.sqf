/*
    File: fn_skills_tierUnlocked.sqf
    Author: Savage Game Design
    Date: 2023-05-20
    Last Update: 2025-06-26
    Public: Yes

    Description:
        Check if player can access specified tier of given skilltree.

    Parameter(s):
        _player - Player to check [OBJECT]
        _skillTree - Skill tree [HashMap]
        _tier - Tier being checked [HashMap]

    Returns:
        Skilltree tier is unlocked [BOOL]

    Example(s):
        [player, ["combatTree"] call vgm_g_fnc_skills_getByPath, 0] call vgm_g_fnc_skills_tierUnlocked
 */

params [
    ["_player", objNull],
    ["_skillTree", createHashMap],
    ["_tier", 0, [0]]
];

private _spentPointsInTreeBelowTier = [_skillTree, _player, _tier] call vgm_g_fnc_skills_getTreeSkillPointsBelowTier;
private _requiredPoints = vgm_skills_tierUnlockCosts # _tier;

_requiredPoints <= _spentPointsInTreeBelowTier
