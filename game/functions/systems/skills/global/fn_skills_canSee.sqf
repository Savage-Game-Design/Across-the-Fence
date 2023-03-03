/*
    File: fn_skills_canShow.sqf
    Author: veteran29
    Date: 2023-01-29
    Last Update: 2023-02-02
    Public: Yes

    Description:
        Check if player can see the skill.

    Parameter(s):
        _player - Player trying to learn the skill [OBJECT]
        _skill - Skill [HashMap]

    Returns:
        Can player see the skill [BOOL]

    Example(s):
        [_player, _skill] call vgm_g_fnc_skills_canSee
 */

params [
    ["_skill", createHashMap, [createHashMap]],
    ["_player", player, [objNull]]
];

([_skill, _player] call vgm_g_fnc_skills_isKnown) || {_player call (_skill get "conditionShow")} // return
