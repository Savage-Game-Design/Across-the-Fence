/*
    File: fn_skill_active_steadyAim.sqf
    Author: Savage Game Design
    Date: 2023-09-14
    Last Update: 2023-09-14
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

["Rifleman/Steady Aim skill activated"] call vgm_g_fnc_logInfo;

[player, "aim", "skill_active_steadyAim", -1] call vgm_c_fnc_coefficient_set;

["skill_active_steadyAim", {
    ["Rifleman/Steady Aim skill exhausted"] call vgm_g_fnc_logInfo;
    [player, "aim", 'skill_active_steadyAim', 0] call vgm_c_fnc_coefficient_set
}, 30, "seconds"] call BIS_fnc_runLater;
