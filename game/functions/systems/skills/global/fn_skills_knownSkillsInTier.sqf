/*
    File: fn_skills_knownSkillsInTier.sqf
    Author: Savage Game Design
    Date: 2023-05-20
    Last Update: 2025-06-25
    Public: Yes

    Description:
        Gets all the skills known by the player, in the given tier.

    Parameter(s):
        _player - Player to check [OBJECT]
        _skillTree - Skill tree [HashMap]
        _tier - Tier being checked [HashMap]

    Returns:
        List of all known skills in that tier [ARRAY]

    Example(s):
        [player, _skillTree, 0] call vgm_g_fnc_skills_knownSkillsInTier
 */

params [
    ["_player", objNull],
    ["_skillTree", createHashMap],
    ["_tier", -1, [0]]
];

private _tiersArray = _skillTree getOrDefault ["skills", []];
private _tierSkills = _tiersArray param [_tier, []];
_tierSkills select {[_x, _player] call vgm_g_fnc_skills_isKnown}
