/*
    File: fn_skills_dbGet.sqf
    Author: veteran29
    Date: 2023-02-28
    Last Update: 2025-07-03
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

#define SKILLS_VERSION 1

params ["_player"];

private _uid = getPlayerUID _player;

["DEBUG", format ["Loading skills data - %1", _uid]] call vgm_g_fnc_log;

private _playerSkillsData = ["player_skills", _uid] call vgm_s_fnc_db_get;
_playerSkillsData set ["skillPoints", 0, true];
_playerSkillsData set ["skillPointsSpent", 0, true];
_playerSkillsData set ["skillPaths", [], true];
_playerSkillsData set ["skillsVersion", SKILLS_VERSION, true];

private _playerLevel = [_player] call vgm_s_fnc_leveling_dataGetCached get "level";
private _levelSkillPoints = [_playerLevel] call vgm_g_fnc_leveling_getLevelInfo get "totalSkillPoints";

// Temporary hack to allow us to reset skills when we've made major skill tree changes,
// or changed the total amount of skill points available to players.
private _skillPointsTotal = (_playerSkillsData get "skillPoints") + (_playerSkillsData get "skillPointsSpent");
private _areSkillPointTotalsInvalid = _skillPointsTotal isNotEqualTo _levelSkillPoints;
private _isWrongVersion = _playerSkillsData get "skillsVersion" isNotEqualTo SKILLS_VERSION;
if (_isWrongVersion || _areSkillPointTotalsInvalid) then {
    private _reasons = [];
    if (_isWrongVersion) then {
        _reasons pushBack format ["wrong version (has: %1, expected %2)", _playerSkillsData get "skillsVersion", SKILLS_VERSION];
    };
    if (_areSkillPointTotalsInvalid) then {
        _reasons pushBack format ["wrong skill point total (has: %1, expected: %2)", _skillPointsTotal, _levelSkillPoints];
    };
    [format ["Resetting player's skill due to %1", _reasons joinString ","]] call vgm_g_fnc_logInfo;
    _playerSkillsData set ["skillPoints", _levelSkillPoints];
    _playerSkillsData set ["skillPointsSpent", 0];
    _playerSkillsData set ["skillPaths", []];
    _playerSkillsData set ["skillsVersion", SKILLS_VERSION];
};


_playerSkillsData // return
