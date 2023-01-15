/*
    File: fn_skills_canLearn.sqf
    Author:
    Date: 2022-12-22
    Last Update: 2023-01-15
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Player can learn the skill [BOOL]

    Example(s):
        _skill call vgm_c_fnc_skills_canLearn
 */

params ["_skill"];

(vgm_skills_points >= (_skill get "cost"))
&& {
    // check if knows at least one skill from previous tier
    private _tier = _skill get "tier";
    if (_tier < 1) exitWith {true};

    private _tiersArray = (_skill call vgm_c_fnc_skills_getSkillTreeFromSkill) get "skills";
    _previousTierSkills = _tiersArray select (_tier - 1);
    _previousTierSkills findIf {(_x get "path") in vgm_skills_knownSkills} > -1 // return
}
&& {player call (_skill get "conditionUnlock")} // return
