/*
    File: fn_respawn_decayInventory.sqf
    Author: Savage Game Design
    Date: 2024-12-06
    Last Update: 2025-06-29
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

#define MAX_LOSS_PERCENTAGE 0.5

params ["_unit"];

private _items = [];
_items append uniformItems _unit;
_items append vestItems _unit;

private _itemCounts = _items call BIS_fnc_consolidateArray;
private _minCounts = createHashMapFromArray [
    [["Item", "FirstAidKit"], 3],
    [["Item", "Medikit"], 1],
    [["Magazine", "Grenade"], 0],
    ["Magazine", 1]
];

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

{
    _x params ["_item", "_count"];
    private _itemType = _item call vgm_g_fnc_itemType;
    private _minAmount = _minCounts getOrDefaultCall [_itemType, {_minCounts getOrDefault [_itemType#0, 0]}];

    private _maxLoss = ceil (_count * MAX_LOSS_PERCENTAGE);
    // Change to not lose anything, that's reduced the more of the thing you have.
    private _toRemove = [0, 1 + floor random _maxLoss] select (random (_count + 1) > 1);
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
