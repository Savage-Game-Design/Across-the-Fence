/*
    File: fn_skill_actives_medic_itsOnlyAFleshWound.sqf
    Author: Savage Game Design
    Date: 2026-01-11
    Last Update: 2026-01-11
    Public: No

    Description:
        Adds logic for Medic It's Only A Flesh Wound skill.

    Parameter(s):
        _target - Target unit to heal [OBJECT]

    Returns:
        Nothing

    Example(s):
        [cursorTarget] call vgm_c_fnc_skill_actives_medic_itsOnlyAFleshWound
 */

params ["_target"];

["vgm_medical_fullHeal", [_target], [_target]] call para_g_fnc_event_triggerTargets;
