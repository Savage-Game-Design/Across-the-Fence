/*
    File: fn_loc_getTargetBoxBounds.sqf
    Author: Savage Game Design
    Date: 2024-08-24
    Last Update: 2024-08-24
    Public: Yes

    Description:
        Gets the position and dimensions of a target box.

    Parameter(s):
        _targetBox - Name of the target box [STRING]

    Returns:
        [ Position2D, [ width / 2, height / 2 ], direction ] [ARRAY]

    Example(s):
        ["oscar8"] call vgm_g_fnc_loc_getTargetBoxBounds;
 */

params ["_targetBox"];

private _marker = format ["tbox_%1", _targetBox];

[
    markerPos _marker,
    markerSize _marker,
    markerDir _marker
]
