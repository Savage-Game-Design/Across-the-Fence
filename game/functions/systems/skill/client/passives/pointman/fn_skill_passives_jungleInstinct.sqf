/*
    File: fn_skill_passives_jungleInstinct.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Gain one extra task hint on the map at the beginning of a mission.
        Sets a trait that the hint system checks when spawning hints.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_jungleInstinct
 */

params ["_known"];

player setUnitTrait ["vgm_skill_jungleInstinct", _known, true];
player setVariable ["vgm_g_skill_jungleInstinct", _known, true];
