/*
    File: fn_posindex_delete.sqf
    Author: Savage Game Design
    Date: 2025-01-09
    Last Update: 2025-01-10
    Public: Yes

    Description:
        Deletes an item.

        This function will run slower on larger indexes.

    Parameter(s):
        _index - Index to delete from [HASHMAP]
        _item - Item to delete [ANY]

    Returns:
        Nothing

    Example(s):
        private _oldEntry = [_index, 0] call vgm_g_fnc_posindex_get;
        [_index, _oldEntry] call vgm_g_fnc_posindex_delete;
 */

params ["_index", "_item"];
private _slot = _index get "items" find _item;

if (_slot < 0) exitWith {};

[_index, _slot] call vgm_g_fnc_posindex_deleteAt;
