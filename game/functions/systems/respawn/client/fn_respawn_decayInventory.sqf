/*
    File: fn_respawn_decayInventory.sqf
    Author: Savage Game Design
    Date: 2024-12-06
    Last Update: 2026-03-05
    Public: No

    Description:
        Removes the rucksack from the player on respawn. The rucksack was
        already dropped at the death location as a lootable ground container.
        All other gear is kept.

    Parameter(s):
        _unit - Unit to process [OBJECT]

    Returns:
        Removed item counts [ARRAY]

    Example(s):
        player call vgm_c_fnc_respawn_decayInventory
 */

params ["_unit"];

private _removedItems = [];

if (backpack _unit != "") then {
    private _backpackItems = backpackItems _unit call BIS_fnc_consolidateArray;
    _removedItems pushBack [1, backpack _unit];
    {
        _x params ["_item", "_count"];
        _removedItems pushBack [_count, _item];
    } forEach _backpackItems;
    removeBackpack _unit;
};

_removedItems // return
