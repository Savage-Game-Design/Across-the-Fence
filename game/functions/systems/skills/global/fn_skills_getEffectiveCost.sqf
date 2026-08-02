/*
    File: fn_skills_getEffectiveCost.sqf
    Author: Atlas
    Date: 2026-03-03
    Public: Yes

    Description:
        Returns the effective SP cost of a skill after applying any training
        discount. If the player has the matching training skill for the tree,
        all OTHER skills in that tree cost 1 SP less (minimum 1).
        The combat tree has no training skill, so no discount applies.

    Parameter(s):
        _skill  - Skill HashMap [HASHMAP]
        _player - Player to check [OBJECT, defaults to player]

    Returns:
        Effective cost [NUMBER]

    Example(s):
        [_skill, player] call vgm_g_fnc_skills_getEffectiveCost
*/

params [
    ["_skill", createHashMap],
    ["_player", player]
];

private _baseCost = _skill get "cost";
private _path = _skill get "path";
private _treeName = _path # 0;
private _skillName = _path # (count _path - 1);

// Map tree → training skill name
private _trainingMap = createHashMapFromArray [
    ["pointman",   "training_pointman"],
    ["teamLeader", "training_team_leader"],
    ["rto",        "training_rto"],
    ["medic",      "training_medic"],
    ["tail",       "training_tail"]
];

// No discount for combat tree or if no training skill exists for this tree
private _trainingSkillName = _trainingMap getOrDefault [_treeName, ""];
if (_trainingSkillName isEqualTo "") exitWith { _baseCost };

// Don't discount the training skill itself
if (_skillName isEqualTo _trainingSkillName) exitWith { _baseCost };

// Check if the player knows the training skill
private _trainingPath = [_treeName, _trainingSkillName];
private _trainingSkill = _trainingPath call vgm_g_fnc_skills_getByPath;
if (isNil "_trainingSkill") exitWith { _baseCost };

if ([_trainingSkill, _player] call vgm_g_fnc_skills_isKnown) exitWith {
    (_baseCost - 1) max 1
};

_baseCost
