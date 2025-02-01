/*
    File: fn_posindex_deleteAt.sqf
    Author: Savage Game Design
    Date: 2025-01-09
    Last Update: 2025-01-10
    Public: Yes

    Description:
        Deletes the item stored in a specific slot.

    Parameter(s):
        _index - Index to delete from [HASHMAP]
        _slot - Slot to empty [NUMBER]

    Returns:
        Nothing

    Example(s):
        [_myIndex, _myItem] call vgm_g_fnc_posindex_deleteAt;
 */

params ["_index", "_slot"];

_index get "positions" set [_slot, nil];
_index get "items" set [_slot, nil];
_index get "vacantSlots" pushBack _slot;

nil
