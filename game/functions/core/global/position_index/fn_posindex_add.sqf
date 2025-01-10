/*
    File: fn_posindex_add.sqf
    Author: Savage Game Design
    Date: 2025-01-09
    Last Update: 2025-01-10
    Public: Yes

    Description:
        Adds an item to a position index.

    Parameter(s):
        _index - Index to add to [HASHMAP]
        _item - Item to add [ANY]

    Returns:
        Position in the index where the item was inserted [NUMBER]

    Example(s):
        private _item = createHashMapFromArray [["pos", [0,0,0]]];
        [_index, _item] call vgm_g_fnc_posindex_add;
 */

params ["_index", "_item"];

private _pos = _item call (_index get "getItemPos");
private _vacantSlots = _index get "vacantSlots";
if (count _vacantSlots > 0) exitWith {
    private _slot = _vacantSlots deleteAt (count _vacantSlots - 1);
    _index get "positions" set [_slot, _pos];
    _index get "items" set [_slot, _item];
    _slot
};
private _slot = _index get "positions" pushBack _pos;
_index get "items" set [_slot, _item];

_slot
