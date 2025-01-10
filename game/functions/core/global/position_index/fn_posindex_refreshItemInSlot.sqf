/*
    File: fn_posindex_refreshItemInSlot.sqf
    Author: Savage Game Design
    Date: 2025-01-09
    Last Update: 2025-01-10
    Public: Yes

    Description:
        Updates the position of the item in the given slot.

    Parameter(s):
        _index - Index to refresh [HASHMAP]
        _slot - Item slot [NUMBER]

    Returns:
        Nothing

    Example(s):
        [_myIndex, 0] call vgm_g_fnc_posindex_refreshItemInSlot;
 */

params ["_index", "_slot"];

private _item = _index get "items" select _slot;
_index get "positions" set [_slot, _item call (_index get "getItemPos")];
