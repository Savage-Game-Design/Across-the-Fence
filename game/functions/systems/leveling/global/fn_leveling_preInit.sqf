/*
    File: fn_preInit.sqf
    Author: Savage Game Design
    Date: 2023-05-30
    Last Update: 2023-06-02
    Public: No

    Description:
        Global preInit function for leveling system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

vgm_g_leveling_levelsHashMap = [missionConfigFile >> "vgm_levels"] call vgm_g_fnc_leveling_parseCfg;
