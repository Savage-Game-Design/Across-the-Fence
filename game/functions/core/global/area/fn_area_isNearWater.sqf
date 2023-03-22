/*
    File: fn_area_isNearWater.sqf
    Author: Savage Game Design
    Date: 2023-03-03
    Last Update: 2023-03-21
    Public: Yes

    Description:
        Checks the area around a position for water.

    Parameter(s):
        _pos - Central position to find average gradient at [ARRAY]
        _radius - Radius to check around position [NUMBER]

    Returns:
        _nearWater - True if water is found [BOOL]

    Example(s):
        [[1500,2000], 20] call vgm_g_fnc_area_isNearWater;
 */

params ["_pos", "_radius"];

private _nearWater = false;

{
    if (surfaceIsWater (_pos getPos [_radius, _x])) then {
        _nearWater = true;

        break;
    };
} forEach [0, 45, 90, 135, 180, 225, 270, 315];

_nearWater
