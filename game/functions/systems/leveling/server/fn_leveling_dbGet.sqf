/*
    File: fn_leveling_dbGet.sqf
    Author: Savage Game Design
    Date: 2023-05-30
    Last Update: 2023-06-01
    Public: No

    Description:
        Get player leveling data from DB.

    Parameter(s):
        _player - Player to get data for [OBJECT]

    Returns:
        Leveling data [HASHMAP]

    Example(s):
        _player call vgm_s_fnc_leveling_dbGet
 */

params ["_player"];

private _uid = getPlayerUID _player;

["DEBUG", format ["Loading leveling data - %1", _uid]] call vgm_g_fnc_log;

private _playerLevelingData = ["player_leveling", _uid] call vgm_s_fnc_db_get;
_playerLevelingData set ["level", 0, true];
_playerLevelingData set ["experience", 0, true];

_playerLevelingData // return
