/*
    File: fn_skills_tierUnlocked.sqf
    Author: Savage Game Design
    Date: 2023-05-20
    Last Update: 2023-05-20
    Public: Yes

    Description:
        Checks if player "invested" in skill tree tier / checks if player has at least one skill in that tier.

    Parameter(s):
        _player - Player to check [OBJECT]
        _skillTree - Skill tree [HashMap]
        _tier - Tier being checked [HashMap]

    Returns:
        Player invested into skill tree tier [BOOL]

    Example(s):
        [player, _skillTree, 0] call vgm_g_fnc_skills_tierInvested
 */

params [
    ["_player", objNull],
    ["_skillTree", createHashMap],
    ["_tier", -1, [0]]
];

private _tiersArray = _skillTree getOrDefault ["skills", []];
private _tierSkills = _tiersArray param [_tier, []];
_tierSkills findIf {[_x, _player] call vgm_g_fnc_skills_isKnown} > -1 // return
