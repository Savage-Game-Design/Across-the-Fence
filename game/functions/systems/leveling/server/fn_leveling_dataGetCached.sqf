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

_player getVariable "vgm_g_levelingData"; // return
