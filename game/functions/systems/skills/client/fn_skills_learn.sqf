/*
    File: fn_skills_learn.sqf
    Author:
    Date: 2022-12-20
    Last Update: 2023-01-15
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [_skill, true] call vgm_c_fnc_skills_learn
 */

params [
    "_skill",
    ["_checkRequirements", true]
];

private _path = _skill get "path";

if (_checkRequirements && {!(_skill call vgm_c_fnc_skills_canLearn)}) exitWith {
    // WARNING_1("Requirements not fullfilled",_skill get "path");
    false // return
};

if (_path in vgm_skills_knownSkills) exitWith {
    // ERROR_1("Skill already known",_skill get "path");
    false // return
};

vgm_skills_points = vgm_skills_points - (_skill get "cost");
vgm_skills_knownSkills set [_path, _skill];

true // return
