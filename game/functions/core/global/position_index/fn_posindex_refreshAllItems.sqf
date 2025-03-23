/*
    File: fn_posindex_refreshAllItems.sqf
    Author: Savage Game Design
    Date: 2025-01-09
    Last Update: 2025-01-24
    Public: Yes

    Description:
        Updates the position of all items.

        Warning: expensive.

    Parameter(s):
        _index - Index to refresh [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [_myIndex] call vgm_g_fnc_posindex_refreshAllItems;
 */

params ["_index"];

private _fnc_getItemPos = _index get "getItemPos";
private _positions = _index get "positions";

{
    if (!isNil "_x") then {
        _positions set [_forEachIndex, _x call _fnc_getItemPos];
    };
} forEach (_index get "items");
