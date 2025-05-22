/*
    File: fn_getLevel.sqf
    Author: Savage Game Design
    Date: 2025-05-23
    Last Update: 2025-05-23
    Public: Yes

    Description:
        Gets the player's current level.

    Parameter(s):
        N/A

    Returns:
        Current level [NUMBER]

    Example(s):
        call vgm_c_fnc_leveling_getLevel;
 */

player getVariable ["leveling_data", createHashMap] getOrDefault ["level", -1]
