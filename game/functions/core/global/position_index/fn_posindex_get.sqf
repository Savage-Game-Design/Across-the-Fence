/*
    File: fn_posindex_get.sqf
    Author: Savage Game Design
    Date: 2025-01-09
    Last Update: 2025-01-10
    Public: Yes

    Description:
        Gets an item by slot number

    Parameter(s):
        _index - Index to query [HASHMAP]
        _slot - Slot [NUMBER]

    Returns:
        Item. Will return the *wrong* item if used with an old slot number. [ANY]

    Example(s):
        private _slot = [_index, myItem] call vgm_g_fnc_posindex_add;
        [_index, _slot] call vgm_g_fnc_posindex_get;
 */

params ["_index", "_slot"];

_index get "items" select _slot
