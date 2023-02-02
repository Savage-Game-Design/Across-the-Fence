/*
    File: fn_skills_isKnown.sqf
    Author: veteran29
    Date: 2023-01-15
    Last Update: 2023-02-02
    Public: Yes

    Description:
        Check if skill is known to the player.

    Parameter(s):
        _skill - Skill hash [HASHMAP]
        _player - Player to check [OBJECT, defaults to player]

    Returns:
        Is skill known [BOOL]

    Example(s):
        _skill call vgm_g_fnc_skills_isKnown
 */

params ["_skill", ["_player", player]];

private _skillsData = _player getVariable "vgm_g_skillsData";
(_skill get "path") in (_skillsData get "skillPaths") // return
