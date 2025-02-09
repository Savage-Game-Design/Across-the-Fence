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

// lifeState can't be used due to an engine bug, which results in the server's `lifeState` being rarely being out of sync with the client's, if they take damage just before being set unconscious. This results in  `INCAPACITATED` on the client, but `INJURED` instead of `INCAPACITATED` on the server. This only lasts for a few frames, but is enough to cause issues.
_unit getVariable "vgm_g_medical_isUnconscious" // return
