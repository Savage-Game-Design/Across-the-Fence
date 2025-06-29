/*
    File: fn_leveling_dbSave.sqf
    Author: Savage Game Design
    Date: 2023-05-30
    Last Update: 2025-06-29
    Public: No

    Description:
        Persists player leveling data to DB.

    Parameter(s):
        _player - Player to persist data for [OBJECT]

    Returns:
        Nothing

    Example(s):
        [_player, _levelingData] call vgm_s_fnc_leveling_dbSave;
 */

params ["_player", "_levelingData"];

private _uid = getPlayerUID _player;
if (isNil "_levelingData") exitWith {
    (format ["No leveling data for player %1 (%2)", name _player, _uid]) call vgm_g_fnc_logError;
    false // return
};

["leveling", _uid, _levelingData] call vgm_s_fnc_db_typed_save;
