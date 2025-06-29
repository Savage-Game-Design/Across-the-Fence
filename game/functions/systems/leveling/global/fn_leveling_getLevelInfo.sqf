/*
    File: fn_leveling_getLevelInfo.sqf
    Author: Savage Game Design
    Date: 2025-06-29
    Last Update: 2025-06-29
    Public: Yes

    Description:
        Retrieves the config values for the given level.

    Parameter(s):
        _level - Level to get info for [NUMBER]

    Returns:
        Level information for the requested level [HASHMAP]

    Example(s):
        [2] call vgm_g_fnc_leveling_getLevelInfo;
 */

params ["_level"];

vgm_g_leveling_levelsHashMap get (0 max _level min vgm_g_leveling_maxLvl)
