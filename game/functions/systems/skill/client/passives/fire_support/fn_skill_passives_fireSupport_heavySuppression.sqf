/*
    File: fn_skill_passives_fireSupport_heavySuppression.sqf
    Author: Savage Game Design
    Date: 2023-10-07
    Last Update: 2023-10-08
    Public: No

    Description:
        Adds logic for Rifleman Tier 1 Heavy Suppression skill.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_fireSupport_heavySuppression
 */

params ["_known"];

if (!_known) exitWith {
    player setVariable ["vgm_g_skill_passives_fireSupport_heavySuppresion", 0, true];
};

player setVariable ["vgm_g_skill_passives_fireSupport_heavySuppresion", 0.5, true];
