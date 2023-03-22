/*
    File: fn_area_getGradient.sqf
    Author: Savage Game Design
    Date: 2023-03-03
    Last Update: 2023-03-21
    Public: Yes

    Description:
        Gets the gradient of the area in degrees.

    Parameter(s):
        _pos - Central position to find average gradient at [ARRAY]

    Returns:
        Gradient in degrees [Number]

    Example(s):
        [position player] call vgm_g_fnc_area_getGradient
 */

params ["_pos", "_radius"];
private _surroundGradients = [];
private _totalGradient = 0;

{
    private _gradientPosition = _pos getPos [_radius, _x];
    private _gradient = abs (aCos ([0,0,1] vectorCos (surfaceNormal _gradientPosition)));

    _totalGradient = _totalGradient + _gradient;

    _surroundGradients pushBack (_gradient);
} forEach [0, 45, 90, 135, 180, 225, 270, 315];

(_totalGradient / (count _surroundGradients)) //result
