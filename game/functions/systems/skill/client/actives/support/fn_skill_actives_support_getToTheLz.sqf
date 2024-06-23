/*
    File: fn_skill_actives_support_getToTheLz.sqf
    Author: Savage Game Design
    Date: 2023-10-08
    Last Update: 2024-06-23
    Public: No

    Description:
        Adds logic for Support Tier 4 Get To The LZ skill.

    Parameter(s):
        none

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skill_actives_support_getToTheLz
 */

["vgm_skill_support_getToTheLz", [_skill get "duration"], units player] call para_g_fnc_event_triggerTargets;
