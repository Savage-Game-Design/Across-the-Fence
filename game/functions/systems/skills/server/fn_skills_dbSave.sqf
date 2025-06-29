/*
    File: fn_skills_dbSave.sqf
    Author: veteran29
    Date: 2023-01-27
    Last Update: 2025-06-29
    Public: No

    Description:
        Persists player skill data to DB.

    Parameter(s):
        _player - Player to persist data for [OBJECT]

    Returns:
        Nothing

    Example(s):
        [_player, _skillsData, {
            params ["_player", "_data"];
        }] call vgm_s_fnc_skills_dbSave
 */

params ["_player", "_skillsData", "_callback", "_arguments"];

private _uid = getPlayerUID _player;

if (isNil "_skillsData") exitWith {
    (format ["No skills data for player %1 (%2)", name _player, _uid]) call vgm_g_fnc_logError;
    false // return
};

["skills", _uid, _skillsData, {
    params ["_data", "_arguments"];

    _arguments params ["_player", "_skillsData", "_callback"];
    _callback params ["_callback", "_arguments"];
    [_player, _data, _skillsData, _arguments] call _callback;
}, [_player, _skillsData, _callback]] call vgm_s_fnc_db_typed_save;
