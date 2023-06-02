/*
    File: fn_leveling_dbSave.sqf
    Author: Savage Game Design
    Date: 2023-05-30
    Last Update: 2023-06-01
    Public: No

    Description:
        Persists player leveling data to DB.

    Parameter(s):
        _player - Player to persist data for [OBJECT]

    Returns:
        Nothing

    Example(s):
        _player call vgm_s_fnc_leveling_dbSave
 */

params ["_player"];

private _uid = getPlayerUID _player;
private _hashMap = _player call vgm_s_fnc_leveling_dataGetCached;
if (isNil "_hashMap") exitWith {
    ["ERROR", format ["VGM: No data for player %1 (%2)", name _player, _uid]] call para_g_fnc_log;
    false // return
};

["player_leveling", _uid, _hashMap] call vgm_s_fnc_db_typed_save;
