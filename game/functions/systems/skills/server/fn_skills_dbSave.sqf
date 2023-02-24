/*
    File: fn_skills_dbSave.sqf
    Author: veteran29
    Date: 2023-01-27
    Last Update: 2023-02-24
    Public: No

    Description:
        Persists player skill data to DB.

    Parameter(s):
        _player - Player to persist data for [OBJECT]

    Returns:
        Nothing

    Example(s):
        _player call vgm_s_fnc_skills_dbSave
 */

params ["_player"];

private _uid = getPlayerUID _player;
private _hashMap = _player call vgm_s_fnc_skills_dbGet;
if (isNil "_hashMap") exitWith {
    ["ERROR", format ["VGM: No data for player %1 (%2)", name _player, _uid]] call para_g_fnc_log;
    false // return
};

["player_skills", _uid, _hashMap] call vgm_s_fnc_db_typed_save;
