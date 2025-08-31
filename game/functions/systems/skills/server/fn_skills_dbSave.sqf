/*
    File: fn_skills_dbSave.sqf
    Author: veteran29
    Date: 2023-01-27
    Last Update: 2025-08-29
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
private _hashMap = _player call vgm_s_fnc_skills_dataGetCached;
if (isNil "_hashMap") exitWith {
    (format ["No skills data for player %1 (%2)", name _player, _uid]) call vgm_g_fnc_logError;
    false // return
};

["skills", _uid, _hashMap] call vgm_s_fnc_persistence_dbSet;
