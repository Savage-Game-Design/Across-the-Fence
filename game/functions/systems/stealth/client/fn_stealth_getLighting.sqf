/*
    File: fn_stealth_getLighting.sqf
    Author: Savage Game Design
    Date: 2025-01-23
    Last Update: 2025-01-23
    Public: No

    Description:
        Lighting level based on ambient + dynamic light level, in the range where it should start making a difference to stealth.

    Parameter(s):
        N/A

    Returns:
        Lighting level between 0 and 1 [NUMBER]

    Example(s):
        [] call vgm_c_fnc_stealth_getLighting;
 */

private _lighting = getLightingAt player;
private _totalLight = (_lighting # 1) + (_lighting # 3);

linearConversion [3, 80, _totalLight, 0, 1, true]
