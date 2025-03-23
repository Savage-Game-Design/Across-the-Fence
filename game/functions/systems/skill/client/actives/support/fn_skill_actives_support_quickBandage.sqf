/*
    File: fn_skill_actives_support_quickBandage.sqf.sqf
    Author: Savage Game Design
    Date: 2023-10-08
    Last Update: 2023-10-08
    Public: No

    Description:
        Adds logic for Support Tier 3 Quick Bandage skill.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skill_actives_support_quickBandage
 */

private _target = cursorTarget;
["vgm_medical_adjustBleedOutAt", [_target, 60], [_target]] call para_g_fnc_event_triggerTargets;
