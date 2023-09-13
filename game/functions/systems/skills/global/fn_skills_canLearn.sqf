/*
    File: fn_skills_canLearn.sqf
    Author: veteran29
    Date: 2022-12-22
    Last Update: 2023-09-14
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
    private _skillTree = _skill call vgm_g_fnc_skills_getSkillTreeFromSkill;
    private _tier = _skill get "tier";
    (
        _tier >= 1
        // we allow only one skill in first tier (0 idx)
        || {!([_player, _skillTree, _tier] call vgm_g_fnc_skills_tierInvested)}
    )
    // check if the tier is unlocked
    && {[_player, _skillTree, _tier] call vgm_g_fnc_skills_tierUnlocked} // return
}
&& {_player call (_skill get "conditionUnlock")} // return
