/*
    File: fn_skill_passives_support_shepherd.sqf
    Author: Savage Game Design
    Date: 2023-10-08
    Last Update: 2024-07-04
    Public: No

    Description:
        Adds logic for Support Tier 1 Shepherd skill.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_support_shepherd
 */

params ["_known"];

vgm_squad_ui_mapDrawEveryone = _known;
