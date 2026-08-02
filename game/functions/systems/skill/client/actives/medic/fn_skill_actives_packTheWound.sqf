/*
    File: fn_skill_actives_packTheWound.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Activates the "Pack the wound" skill.
        For the duration, each heal interaction removes 2 wound levels
        instead of 1.

    Parameter(s):
        _activatingUnit - Unit activating skill [UNIT]
        _skill - Skill hashmap [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skill_actives_packTheWound
 */

params ["", "_skill"];

["Pack the wound skill activated"] call vgm_g_fnc_logInfo;

// Set treatment data to 2 wounds per heal
vgm_medical_healItemsTreatmentData set ["fak", 2];
vgm_medical_healItemsTreatmentData set ["medikit", 2];

// Schedule cleanup: restore to 1 wound per heal
["skill_packTheWound", {
    ["Pack the wound skill exhausted"] call vgm_g_fnc_logInfo;
    vgm_medical_healItemsTreatmentData set ["fak", 1];
    vgm_medical_healItemsTreatmentData set ["medikit", 1];
}, _skill get "duration", "seconds"] call BIS_fnc_runLater;
