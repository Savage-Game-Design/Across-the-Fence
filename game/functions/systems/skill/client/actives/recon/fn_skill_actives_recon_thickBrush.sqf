/*
    File: fn_skill_actives_recon_thickBrush.sqf
    Author: Savage Game Design
    Date: 2023-10-06
    Last Update: 2023-10-06
    Public: No

    Description:
        Adds logic for Recon Tier 4 Thick Brush skill.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skill_actives_recon_thickBrush
 */

["Recon/6th Sense skill activated"] call vgm_g_fnc_logInfo;

[player, 'camouflage', 'skill_recon_thickBrush', -1] call vgm_c_fnc_coefficient_set;
[player, 'audible', 'skill_recon_thickBrush', -1] call vgm_c_fnc_coefficient_set;

["skill_active_sixthSense", {
    ["Recon/6th Sense skill exhausted"] call vgm_g_fnc_logInfo;

    [player, 'camouflage', 'skill_recon_thickBrush'] call vgm_c_fnc_coefficient_remove;
    [player, 'audible', 'skill_recon_thickBrush'] call vgm_c_fnc_coefficient_remove;
}, 60, "seconds"] call BIS_fnc_runLater;
