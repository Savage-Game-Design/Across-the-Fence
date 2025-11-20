/*
    File: fn_nearestPosition.sqf
    Author: Savage Game Design
    Date: 2025-11-20
    Last Update: 2025-11-20
    Public: Yes

    Description:
        Finds the nearest position from a list.

        Runs 4x faster than BIS_fnc_nearestPosition.

    Parameter(s):
        _list - List of positions [ARRAY]
        _origin - Origin to compare to [ARRAY]

    Returns:
        Nearest position [ARRAY]

    Example(s):
        [[[0, 0], [999, 999]], [5, 5]] call vgm_g_fnc_nearestPosition;
 */

params ["_list", "_origin"];

private _arr = _list apply { [_x, _x distanceSqr _origin] };
_arr sort true;

_arr # 0 # 0
