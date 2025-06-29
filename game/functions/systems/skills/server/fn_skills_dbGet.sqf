/*
    File: fn_skills_dbGet.sqf
    Author: veteran29
    Date: 2023-02-28
    Last Update: 2025-06-29
    Public: No

    Description:
        Get player skill data from DB.

    Parameter(s):
        _player - Player to get data for [OBJECT]

    Returns:
        Skill data [HASHMAP]

    Example(s):
        [_player, {
            params ["_player", "_skillsData"];
        }] call vgm_s_fnc_skills_dbGet
 */

params ["_player", "_callback"];

private _uid = getPlayerUID _player;

["DEBUG", format ["Loading skills data - %1", _uid]] call vgm_g_fnc_log;

["skills", _uid, {
    params ["_data", "_arguments"];

    _data set ["skillPoints", 0, true];
    _data set ["skillPointsSpent", 0, true];
    _data set ["skillPaths", [], true];

    _arguments params ["_player", "_callback"];
    [_player, _data] call _callback;
}, [_player, _callback]] call vgm_s_fnc_db_get;


