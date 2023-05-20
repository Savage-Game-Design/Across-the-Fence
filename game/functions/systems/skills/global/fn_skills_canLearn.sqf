/*
    File: fn_skills_canLearn.sqf
    Author: veteran29
    Date: 2022-12-22
    Last Update: 2023-05-20
    Public: Yes

    Description:
        Check if player is eligible for learning given skill.

    Parameter(s):
        _player - Player trying to learn the skill [OBJECT]
        _skill - Skill [HashMap]

    Returns:
        Player can learn the skill [BOOL]

    Example(s):
        [player, _skill] call vgm_g_fnc_skills_canLearn
 */

params [
    ["_player", objNull],
    ["_skill", createHashMap]
];

private _skillsData = _player getVariable ["vgm_g_skillsData", createHashMap];

((_skillsData getOrDefault ["skillPoints", 0]) >= (_skill get "cost"))
&& {
    private _skillTree = _skill call vgm_c_fnc_skills_getSkillTreeFromSkill;
    private _tier = _skill get "tier";

    // first tier specific checks
    if (_tier < 1) exitWith {
        // we allow only one skill in first tiers
        if ([_player, _skillTree, _tier] call vgm_g_fnc_skills_tierInvested) exitWith {false};

        private _path = _skill get "path";
        // no previous tree, always unlocked
        if (count _path < 3) exitWith {true};

        // get path of the parent skill tree
        _path = _path select [0, count _path - 2];
        private _parentSkillTree = _path call vgm_g_fnc_skills_getByPath;
        private _tiersCount = count (_parentSkillTree get "skills");

        // check if last tier of previous tree is unlocked
        private _lastTierPrevTree = _tiersCount - 1;
        [_player, _parentSkillTree, _lastTierPrevTree] call vgm_g_fnc_skills_tierInvested // return
    };

    // check if knows at least one skill from previous tier
    [_player, _skillTree, _tier - 1] call vgm_g_fnc_skills_tierInvested // return
}
&& {_player call (_skill get "conditionUnlock")} // return
