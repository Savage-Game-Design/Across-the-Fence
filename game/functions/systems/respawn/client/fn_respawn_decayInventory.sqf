/*
    File: fn_respawn_decayInventory.sqf
    Author: Savage Game Design
    Date: 2024-12-06
    Last Update: 2025-01-19
    Public: No

    Description:
        Removes items from inventory upons respawn, simulating them getting lost upon the desperate run-away from capture.

    Parameter(s):
        _unit - Unit to decay the inventory of [OBJECT]

    Returns:
        Removed item counts [ARRAY]

    Example(s):
        player call vgm_c_fnc_respawn_decayInventory
 */

params ["_unit"];

private _items = [];
_items append uniformItems _unit;
_items append vestItems _unit;
_items append backpackItems _unit;

private _itemCounts = _items call BIS_fnc_consolidateArray;
private _minCounts = createHashMapFromArray [
    [["Item", "FirstAidKit"], 3],
    [["Magazine", "Grenade"], 0],
    ["Magazine", 1]
];

private _removedItems = [];
{
    _x params ["_item", "_count"];
    private _itemType = _item call vgm_g_fnc_itemType;
    private _minAmount = _minCounts getOrDefaultCall [_itemType, {_minCounts getOrDefault [_itemType#0, 0]}];

    private _toRemove = (_count * 0.25) max 1;
    private _remaining = floor (_count - _toRemove) max _minAmount;
    private _countToRemove = _count - _remaining;
    if (_countToRemove < 1) then {continue};

    format ["Decaying item amount: %1, from %2 to %3", _item, _count, _remaining] call vgm_g_fnc_logInfo;

    _removedItems pushBack [_countToRemove, _item];

    for "_i" from 1 to _countToRemove do {
        _unit removeItem _item;
    };

} forEach _itemCounts;

_removedItems // return
