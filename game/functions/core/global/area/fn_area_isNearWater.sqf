/*
    File: fn_area_isNearWater.sqf
    Author: Savage Game Design
    Date: 2023-03-03
    Last Update: 2023-03-06
    Public: Yes

    Description:
        No description added yet.

    Parameter(s):
        0: Position [ARRAY]
        1: Radius [NUMBER]

    Returns:
        Something [BOOL]

    Example(s):
        [[1500,2000], 20] call vgm_g_fnc_area_isNearWater;
 */

params ["_pos", "_radius"];

private _nearWater = false;

{
    if (surfaceIsWater (_pos getPos [_radius, _x])) then {
        _nearWater = true;
    };
} forEach [0, 45, 90, 135, 180, 225, 270, 315];

_nearWater
