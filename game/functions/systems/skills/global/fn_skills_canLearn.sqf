/*
    File: fn_skills_canLearn.sqf
    Author: veteran29
    Date: 2022-12-22
    Last Update: 2023-01-27
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
    // check if knows at least one skill from previous tier
    private _tier = _skill get "tier";
    if (_tier < 1) exitWith {true};

    // TODO handle previous trees required for subtrees
    private _tiersArray = (_skill call vgm_c_fnc_skills_getSkillTreeFromSkill) get "skills";
    _previousTierSkills = _tiersArray select (_tier - 1);
    _previousTierSkills findIf {_x call vgm_c_fnc_skills_isKnown} > -1 // return
}
&& {_player call (_skill get "conditionUnlock")} // return
