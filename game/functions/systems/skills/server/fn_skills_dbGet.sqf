/*
    File: fn_skills_dbGet.sqf
    Author: veteran29
    Date: 2023-02-28
    Last Update: 2023-02-28
    Public: No

    Description:
        Get player skill data from DB.

    Parameter(s):
        _player - Player to get data for [OBJECT]

    Returns:
        Skill data [HASHMAP]

    Example(s):
        _player call vgm_s_fnc_skills_dbGet
 */

params ["_player"];

private _uid = getPlayerUID _player;

["DEBUG", format ["Loading skills data - %1", _uid]] call vgm_g_fnc_log;

private _playerSkillsData = ["player_skills", _uid] call vgm_s_fnc_db_get;
_playerSkillsData set ["skillPoints", 0, true];
_playerSkillsData set ["skillPointsSpent", 0, true];
_playerSkillsData set ["skillPaths", [], true];

_playerSkillsData // return
