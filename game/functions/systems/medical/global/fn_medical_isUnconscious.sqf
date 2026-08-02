/*
    File: fn_medical_isUnconscious.sqf
    Author: Savage Game Design
    Date: 2025-02-06
    Last Update: 2026-03-05
    Public: Yes

    Description:
        Check unconsciousness state of a unit.
        Bridges SOG Advanced Revive (players) and VGM medical (AI targets
        in snatch/bright light missions).

    Parameter(s):
        _unit - Unit to check

    Returns:
        Unconscious state [BOOL]

    Example(s):
        player call vgm_g_fnc_medical_isUnconscious
 */

params ["_unit"];

// SOG revive sets vn_revive_incapacitated on players
// VGM sets vgm_g_medical_isUnconscious on AI mission targets (snatch, bright light)
(_unit getVariable ["vn_revive_incapacitated", false])
|| {_unit getVariable ["vgm_g_medical_isUnconscious", false]} // return
