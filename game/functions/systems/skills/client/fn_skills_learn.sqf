/*
    File: fn_skills_learn.sqf
    Author:
    Date: 2022-12-20
    Last Update: 2023-01-22
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
    ["_skill", createHashMap, [createHashMap]],
    ["_checkRequirements", true]
];

if (_skill isEqualTo createHashMap) exitWith {
    ["ERROR", "VGM: Empty skill hash"] call para_g_fnc_log;
    false
};

if (_checkRequirements && {!(_skill call vgm_c_fnc_skills_canLearn)}) exitWith {
    ["WARNING", format ["VGM: Skill requirements not fullfilled -  '%1'", _skill get "path"]] call para_g_fnc_log;
    false // return
};

if (_skill call vgm_c_fnc_skills_isKnown) exitWith {
    ["WARNING", format ["VGM: Skill already known - '%1'", _skill get "path"]] call para_g_fnc_log;
    false // return
};

["INFO", format ["VGM: Learning skill '%1'", _skill get "path"]] call para_g_fnc_log;

vgm_skills_points = vgm_skills_points - (_skill get "cost");
vgm_skills_knownSkills set [_skill get "path", _skill];

player call (_skill get "codeApply");

true // return
