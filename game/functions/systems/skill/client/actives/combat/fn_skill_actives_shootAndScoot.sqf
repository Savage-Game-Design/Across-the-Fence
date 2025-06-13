/*
    File: fn_skill_actives_shootAndScoot.sqf
    Author: Savage Game Design
    Date: 2023-09-14
    Last Update: 2025-06-13
    Public: No

    Description:
        Activates the "Shoot and scoot" skill.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skill_actives_shootAndScoot;
 */

params ["", "_skill"];

["Rifleman/Shoot and scoot skill activated"] call vgm_g_fnc_logInfo;

[player, "aim", "skill_active_shootAndScoot", -1] call vgm_c_fnc_coefficient_set;

["skill_active_shootAndScoot", {
    ["Rifleman/Shoot and scoot skill exhausted"] call vgm_g_fnc_logInfo;
    [player, "aim", "skill_active_shootAndScoot"] call vgm_c_fnc_coefficient_remove
}, _skill get "duration", "seconds"] call BIS_fnc_runLater;
