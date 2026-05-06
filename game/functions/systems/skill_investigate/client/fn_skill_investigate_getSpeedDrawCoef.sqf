/*
    File: fn_skill_investigate_getSpeedDrawCoef.sqf
    Author: Savage Game Design
    Date: 2024-01-22
    Last Update: 2026-05-06
    Public: No

    Description:
        Get icon size coef based on speed.

    Parameter(s):
        _speed - Speed for coef [NUMBER]

    Returns:
        Icon draw size coef [NUMBER]

    Example(s):
        (abs speed _object) call vgm_c_fnc_skill_investigate_getSpeedDrawCoef
 */

params ["_speed"];

private _progress = linearConversion [0, 18, _speed, 0, 1, true];
_progress bezierInterpolation [
    [0.25, 0, 0],
    [0.5, 0, 0],
    [0.6, 0, 0],
    [0.8, 0, 0],
    [0.9, 0, 0],
    [0.9, 0, 0],
    [0.9, 0, 0],
    [1.5, 0, 0]
] params ["_coef"];

_coef // return
