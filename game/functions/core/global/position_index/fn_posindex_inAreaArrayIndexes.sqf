/*
    File: fn_posindex_inAreaArrayIndexes.sqf
    Author: Savage Game Design
    Date: 2025-01-09
    Last Update: 2025-01-11
    Public: Yes

    Description:
        Returns the slot numbers of items in the given area.

    Parameter(s):
        _index - Index to query [HASHMAP]
        _query - Parameters for inAreaArrayIndexes [ARRAY]

    Returns:
        Slot numbers of items in the area [ARRAY]

    Example(s):
        [_myIndex, [[0,0,0], 30, 30]] call vgm_g_fnc_posindex_inAreaArrayIndexes;

 */

params ["_index", "_query"];

(_index get "positions") inAreaArrayIndexes _query
