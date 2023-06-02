/*
    File: fn_leveling_dbGetCached.sqf
    Author: Savage Game Design
    Date: 2023-05-30
    Last Update: 2023-06-01
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
    _hashMap = _player call vgm_s_fnc_leveling_dbGet;
    _player setVariable ["vgm_g_levelingData", _hashMap];
};

_hashMap // return
