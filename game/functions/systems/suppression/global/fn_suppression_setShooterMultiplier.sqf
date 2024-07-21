/*
    File: fn_suppression_setShooterMultiplier.sqf
    Author: Savage Game Design
    Date: 2024-02-09
    Last Update: 2024-02-09
    Public: Yes

    Description:
        Multiplies the suppression if it originates from the given unit.

    Parameter(s):
        _shooter - Unit the suppression will be coming from [OBJECT]
        _multiplier - Amount to multiply suppression by [NUMBER]

    Returns:
        Nothing

    Example(s):
        [player, 0.2] call vgm_g_fnc_suppression_setShooterMultiplier
 */

params ["_shooter", "_multiplier"];

_shooter setVariable ["vgm_g_suppression_multiplier", _multiplier, true];
