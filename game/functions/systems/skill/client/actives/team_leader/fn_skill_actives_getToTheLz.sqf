/*
    File: fn_skill_actives_getToTheLz.sqf
    Author: Savage Game Design
    Date: 2023-10-08
    Last Update: 2025-11-29
    Public: No

    Description:
        Boots anim speed, hit shrug chance, and reduces stamina drain for the duration.

    Parameter(s):
        _unit - Unit activating skill [UNIT]
        _skill - Skill being activated [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skill_actives_getToTheLz
 */

params ["", "_skill"];

private _duration = _skill get "duration";

["Support/To The LZ skill activated"] call vgm_g_fnc_logInfo;

[player, "animSpeed", "skill_getToTheLz", 0.1] call vgm_c_fnc_coefficient_set;
[player, "hitShrug", "skill_getToTheLz", 0.4] call vgm_c_fnc_coefficient_set;
[player, "staminaDrain", "skill_getToTheLz", -0.3] call vgm_c_fnc_coefficient_set;

["skill_support_getToTheLz", {
    ["Support/Get To The LZ skill exhausted"] call vgm_g_fnc_logInfo;

    [player, "animSpeed", "skill_getToTheLz"] call vgm_c_fnc_coefficient_remove;
    [player, "hitShrug", "skill_getToTheLz"] call vgm_c_fnc_coefficient_remove;
    [player, "staminaDrain", "skill_getToTheLz"] call vgm_c_fnc_coefficient_remove;
}, _duration, "seconds"] call BIS_fnc_runLater;
