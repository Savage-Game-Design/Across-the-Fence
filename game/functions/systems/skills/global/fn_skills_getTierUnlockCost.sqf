/*
    File: fn_skills_getTierUnlockCost.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: Yes

    Description:
        Returns the effective tier unlock cost for a skill tree tier.
        If the player has the training skill for the tree, the cost is
        reduced by 1 (minimum 0).

    Parameter(s):
        _skillTree - Skill tree HashMap [HASHMAP]
        _player    - Player to check [OBJECT, defaults to player]
        _tier      - Tier index [NUMBER]

    Returns:
        Effective tier unlock cost [NUMBER]

    Example(s):
        [_skillTree, player, 3] call vgm_g_fnc_skills_getTierUnlockCost
*/

params [
    ["_skillTree", createHashMap],
    ["_player", player],
    ["_tier", 0, [0]]
];

private _baseCost = vgm_skills_tierUnlockCosts # _tier;

private _treeName = _skillTree get "path";

// Map tree -> training skill name
private _trainingMap = createHashMapFromArray [
    ["pointman",   "training_pointman"],
    ["teamLeader", "training_team_leader"],
    ["rto",        "training_rto"],
    ["medic",      "training_medic"],
    ["tail",       "training_tail"]
];

private _trainingSkillName = _trainingMap getOrDefault [_treeName, ""];
if (_trainingSkillName isEqualTo "") exitWith { _baseCost };

private _trainingPath = [_treeName, _trainingSkillName];
private _trainingSkill = _trainingPath call vgm_g_fnc_skills_getByPath;
if (isNil "_trainingSkill") exitWith { _baseCost };

if ([_trainingSkill, _player] call vgm_g_fnc_skills_isKnown) exitWith {
    (_baseCost - 1) max 0
};

_baseCost
