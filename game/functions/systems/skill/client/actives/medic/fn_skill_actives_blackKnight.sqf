/*
    File: fn_skill_actives_blackKnight.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Activates the "Black knight" skill.
        Temporarily applies large negative counter-coefficients to offset
        injury debuffs on each team member (runs via codeActivateGroup).
        Does NOT override movement status effects from severe wounds.

    Parameter(s):
        _activatingUnit - Unit activating skill [UNIT]
        _skill - Skill hashmap [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skill_actives_blackKnight
 */

params ["", "_skill"];

["Black knight skill activated"] call vgm_g_fnc_logInfo;

// Apply large counter-coefficients to negate injury effects
[player, "recoil", "skill_blackKnight", -2] call vgm_c_fnc_coefficient_set;
[player, "aim", "skill_blackKnight", -2] call vgm_c_fnc_coefficient_set;
[player, "throw", "skill_blackKnight", 2] call vgm_c_fnc_coefficient_set;
[player, "interact", "skill_blackKnight", -2] call vgm_c_fnc_coefficient_set;
[player, "staminaDrain", "skill_blackKnight", -0.5] call vgm_c_fnc_coefficient_set;

// Schedule cleanup
["skill_blackKnight", {
    ["Black knight skill exhausted"] call vgm_g_fnc_logInfo;

    [player, "recoil", "skill_blackKnight"] call vgm_c_fnc_coefficient_remove;
    [player, "aim", "skill_blackKnight"] call vgm_c_fnc_coefficient_remove;
    [player, "throw", "skill_blackKnight"] call vgm_c_fnc_coefficient_remove;
    [player, "interact", "skill_blackKnight"] call vgm_c_fnc_coefficient_remove;
    [player, "staminaDrain", "skill_blackKnight"] call vgm_c_fnc_coefficient_remove;
}, _skill get "duration", "seconds"] call BIS_fnc_runLater;
