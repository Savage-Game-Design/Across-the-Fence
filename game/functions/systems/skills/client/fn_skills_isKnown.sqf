/*
    File: fn_skills_isKnown.sqf
    Author:
    Date: 2023-01-15
    Last Update: 2023-01-15
    Public: Yes

    Description:
        Check if skill is known.

    Parameter(s):
        _skill - Skill hash [HashMap]

    Returns:
        Is skill known [BOOL]

    Example(s):
        _skill call vgm_c_fnc_skills_isKnown
 */

params ["_skill"];

(_skill get "path") in vgm_skills_knownSkills // return
