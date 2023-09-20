/*
    File: fn_skill_active_steadyAim.sqf
    Author: Savage Game Design
    Date: 2023-09-14
    Last Update: 2023-09-20
    Public: No

    Description:
        Adds logic for Rifleman Tier 3 Steady Aim skill.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skill_actives_steadyAim;
 */

["Rifleman/Steady Aim skill activated"] call vgm_g_fnc_logInfo;

[player, "aim", "skill_active_steadyAim", -1] call vgm_c_fnc_coefficient_set;

["skill_active_steadyAim", {
    ["Rifleman/Steady Aim skill exhausted"] call vgm_g_fnc_logInfo;
    [player, "aim", 'skill_active_steadyAim', 0] call vgm_c_fnc_coefficient_set
}, 30, "seconds"] call BIS_fnc_runLater;
