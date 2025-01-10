/*
    File: fn_posindex_inAreaArray.sqf
    Author: Savage Game Design
    Date: 2025-01-09
    Last Update: 2025-01-11
    Public: Yes

    Description:
        Returns items in the given area.

    Parameter(s):
        _index - Index to query [HASHMAP]
        _query - Query (as accepted by inAreaArrayIndexes) [ARRAY]

    Returns:
        Items in the given area [ARRAY]

    Example(s):
        [_myIndex, [[0,0,0], 30, 30]] call vgm_g_fnc_posindex_inAreaArray;
 */

params ["_index", "_query"];

private _indexes = _this call vgm_g_fnc_posindex_inAreaArrayIndexes;
private _items = _index get "items";
_indexes apply {_items select _x}
