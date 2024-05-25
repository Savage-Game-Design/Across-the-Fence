/*
    File: fn_preInit.sqf
    Author: Savage Game Design
    Date: 2023-05-30
    Last Update: 2023-10-06
    Public: No

    Description:
        Global preInit function for leveling system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

vgm_g_leveling_levelsHashMap = [missionConfigFile >> "vgm_levels"] call vgm_g_fnc_leveling_parseLevelsCfg;
vgm_g_leveling_maxLvl = selectMax keys vgm_g_leveling_levelsHashMap;
vgm_g_leveling_maxExperience = vgm_g_leveling_levelsHashMap get (vgm_g_leveling_maxLvl-1) get "experienceThreshold";
