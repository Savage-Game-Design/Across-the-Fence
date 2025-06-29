/*
    File: fn_leveling_dbGet.sqf
    Author: Savage Game Design
    Date: 2023-05-30
    Last Update: 2025-06-29
    Public: No

    Description:
        Get player leveling data from DB.

    Parameter(s):
        _player - Player to get data for [OBJECT]

    Returns:
        Nothing

    Example(s):
        [_player, {
            params ["_player", "_data"];
        }] call vgm_s_fnc_leveling_dbGet
 */

params ["_player", "_callback"];

private _uid = getPlayerUID _player;

["DEBUG", format ["Loading leveling data - %1", _uid]] call vgm_g_fnc_log;

["leveling", _uid, {
    params ["_data", "_arguments"];

    _data set ["level", 0, true];
    _data set ["experience", 0, true];

    _arguments params ["_player", "_callback"];
    [_player, _data] call _callback;
}, [_player, _callback]] call vgm_s_fnc_db_get;
