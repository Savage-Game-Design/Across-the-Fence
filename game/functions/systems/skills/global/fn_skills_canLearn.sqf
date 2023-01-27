/*
    File: fn_skills_canLearn.sqf
    Author: veteran29
    Date: 2022-12-22
    Last Update: 2023-01-28
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

private _fnc_tierUnlocked = {
    params ["_tree", "_tier"];

    private _tiersArray = _tree get "skills";
    _tierSkills = _tiersArray select (_tier - 1);
    _tierSkills findIf {_x call vgm_c_fnc_skills_isKnown} > -1 // return
};

((_skillsData getOrDefault ["skillPoints", 0]) >= (_skill get "cost"))
&& {

    private _tier = _skill get "tier";
    // if first tier check if has previous tree
    if (_tier < 1) exitWith {
        private _path = _skill get "path";
        // no previous tree, always unlocked
        if (count _path < 3) exitWith {true};

        _path = _path select [0, count _path - 2];
        private _skillTree = _path call vgm_g_fnc_skills_getByPath;
        private _tiersCount = count (_skillTree get "skills");
        diag_log [_skillTree get "displayName", count (_skillTree get "skills")];

        [_skillTree, _tiersCount] call _fnc_tierUnlocked // return
    };

    // check if knows at least one skill from previous tier
    [
        _skill call vgm_c_fnc_skills_getSkillTreeFromSkill,
        _tier
    ] call _fnc_tierUnlocked // return
}
&& {_player call (_skill get "conditionUnlock")} // return
