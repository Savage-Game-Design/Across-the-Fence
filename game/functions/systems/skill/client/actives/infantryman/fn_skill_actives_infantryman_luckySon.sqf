/*
    File: fn_skill_actives_infantryman_luckySon.sqf
    Author: Savage Game Design
    Date: 2023-09-20
    Last Update: 2023-09-23
    Public: No

    Description:
        Adds logic for Rifleman Tier 3 Lucky-Son skill.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skill_actives_infantryman_luckySon;
 */

["Rifleman/Lucky-Son skill activated"] call vgm_g_fnc_logInfo;

[player, "hitShrug", "skill_active_luckySon", 0.8] call vgm_c_fnc_coefficient_set;

["skill_active_luckySon", {
    ["Rifleman/Lucky-Son skill exhausted"] call vgm_g_fnc_logInfo;
    [player, "hitShrug", "skill_active_luckySon"] call vgm_c_fnc_coefficient_remove;
}, 20, "seconds"] call BIS_fnc_runLater;
