/*
    File: fn_leveling_dbGetCached.sqf
    Author: Savage Game Design
    Date: 2023-05-30
    Last Update: 2025-06-29
    Public: No

    Description:
        Get player leveling data from local cache.

    Parameter(s):
        _player - Player to get the leveling data for [OBJECT]

    Returns:
        Player leveling data [HASHMAP]

    Example(s):
        _player call vgm_s_fnc_leveling_dataGetCached
 */

params ["_player"];

private _hashMap = _player getVariable "vgm_g_levelingData";
if (isNil "_hashMap") then {
    format ["Leveling cached data is nil: %1", _player] call vgm_g_fnc_logError;
};

_hashMap // return
