/*
    File: fn_posindex_refreshAllItems.sqf
    Author: Savage Game Design
    Date: 2025-01-09
    Last Update: 2025-01-10
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

private _getItemPos = _index get "getItemPos";
private _positions = _index get "positions";

{
    if (!isNil "_x") then {
        _positions set [_forEachIndex, _x call _getItemPos];
    };
} forEach (_index get "items");
