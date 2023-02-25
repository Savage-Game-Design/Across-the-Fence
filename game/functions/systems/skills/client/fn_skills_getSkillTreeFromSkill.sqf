/*
    File: fn_skills_getSkillTreeFromSkill.sqf
    Author: veteran29
    Date: 2022-12-22
    Last Update: 2023-02-25
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        _skill - Skill hash [HashMap]

    Returns:
        Skill tree [HashMap]

    Example(s):
        _skill call vgm_c_fnc_skills_getSkillTreeFromSkill
 */

params ["_skill"];

private _path = +(_skill get "path");

private _item = vgm_skills_treesHashMap get (_path deleteAt 0);
while {true} do {
    if (count _path == 1) exitWith {
        _item // return
    };

    _item = _item get "subtreesHash" get (_path deleteAt 0);
};
