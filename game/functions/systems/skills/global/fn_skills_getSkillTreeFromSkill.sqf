/*
    File: fn_skills_getSkillTreeFromSkill.sqf
    Author: veteran29
    Date: 2022-12-22
    Last Update: 2023-05-20
    Public: No

    Description:
        Get parent skill from from a skill.

    Parameter(s):
        _skill - Skill hashmap [HASHMAP]

    Returns:
        Skill tree [HASHMAP]

    Example(s):
        _skill call vgm_g_fnc_skills_getSkillTreeFromSkill
 */

params ["_skill"];

private _path = +(_skill get "path");

private _item = vgm_skills_treesHashMap get (_path deleteAt 0);
while {true} do {
    if (count _path <= 1) exitWith {
        _item // return
    };

    _item = _item get "subtreesHash" get (_path deleteAt 0);
} // return
