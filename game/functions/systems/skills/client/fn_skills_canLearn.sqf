/*
    File: fn_skills_canLearn.sqf
    Author:
    Date: 2022-12-22
    Last Update: 2022-12-22
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Player can learn the skill [BOOL]

    Example(s):
        [parameter] call vgm_c_fnc_skills_canLearn
 */

params ["_skill"];

(vgm_skills_points < (_skill get "cost"))
&& {
    // check if knows at least one skill from previous tier
    private _tier = _skill get "tier";
    if (_tier < 1) exitWith {true};

    // TODO do we need to check this? Is this skill API responsibility or should it be handled by UI?
    // (it would be easier in UI most likely)
    private _tiersArray = (_skill call vgm_c_fnc_skills_getSkillTreeFromSkill) get "skills";
    _tiersArray select (_tier - 1) findIf {_x in vgm_skills_knownSkills} > -1 // return
}
&& {player call (_skill get "conditionUnlock")} // return
