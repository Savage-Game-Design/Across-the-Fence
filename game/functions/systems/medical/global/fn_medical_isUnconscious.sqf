/*
    File: fn_medical_isUnconscious.sqf
    Author: Savage Game Design
    Date: 2025-02-06
    Last Update: 2025-02-06
    Public: Yes

    Description:
        Check unconsciousness state of an unit.

    Parameter(s):
        _unit - Unit to check

    Returns:
        Unconscious state [BOOL]

    Example(s):
        player call vgm_g_fnc_medical_isUnconscious
 */

params ["_unit"];

_unit getVariable "vgm_g_medical_isUnconscious" // return
