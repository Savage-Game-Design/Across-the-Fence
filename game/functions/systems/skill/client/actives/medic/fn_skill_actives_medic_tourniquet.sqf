/*
    File: fn_skill_actives_medic_tourniquet.sqf
    Author: Savage Game Design
    Date: 2023-10-08
    Last Update: 2026-01-20
    Public: No

    Description:
        Adds logic for Medic Tier 2 Tourniquet skill.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skill_actives_medic_tourniquet
 */

private _target = cursorTarget;
if (isNull _target) exitWith {_target = player};

["vgm_medical_stopBleeding", [_target], [_target]] call para_g_fnc_event_triggerTargets;
