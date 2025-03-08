/*
    File: fn_posindex_get.sqf
    Author: Savage Game Design
    Date: 2025-01-09
    Last Update: 2025-03-01
    Public: Yes

    Description:
        Gets all items in the posIndex, with no order guarantees.

    Parameter(s):
        _index - Index to query [HASHMAP]

    Returns:
        All items [ARRAY]

    Example(s):
        [_index] call vgm_g_fnc_posindex_getItems;
 */

params ["_index"];

values (_index get "itemsMap")
