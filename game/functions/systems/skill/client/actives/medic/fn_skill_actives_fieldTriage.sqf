/*
    File: fn_skill_actives_fieldTriage.sqf
    Author: AtlasActual
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Field Triage active ability. Called on each group member via codeActivateGroup.
        Sets +0.5 bleedOut (slower bleed-out) and -0.5 interact (faster healing)
        for the skill's duration (30s).

    Parameter(s):
        _activatingUnit - Unit activating skill [UNIT]
        _skill - Skill hashmap [HASHMAP]

    Returns:
        Nothing

    Example(s):
        _this call vgm_c_fnc_skill_actives_fieldTriage
 */

params ["", "_skill"];

["Field triage skill activated"] call vgm_g_fnc_logInfo;

// Apply healing coefficients
[player, "bleedOut", "skill_fieldTriage", 0.5] call vgm_c_fnc_coefficient_set;
[player, "interact", "skill_fieldTriage", -0.5] call vgm_c_fnc_coefficient_set;

// Schedule cleanup after duration
["skill_fieldTriage", {
    ["Field triage skill exhausted"] call vgm_g_fnc_logInfo;

    [player, "bleedOut", "skill_fieldTriage"] call vgm_c_fnc_coefficient_remove;
    [player, "interact", "skill_fieldTriage"] call vgm_c_fnc_coefficient_remove;
}, _skill get "duration", "seconds"] call BIS_fnc_runLater;
