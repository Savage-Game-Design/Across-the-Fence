/*
    File: fn_respawn_decayInventory.sqf
    Author: Savage Game Design
    Date: 2024-12-06
    Last Update: 2024-12-06
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
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

{
    _x params ["_item", "_count"];
    private _itemType = _item call vgm_g_fnc_itemType;
    private _minAmount = _minCounts getOrDefaultCall [_itemType, {_minCounts getOrDefault [_itemType#0, 0]}];

    private _toRemove = (_count * 0.25) max 1;
    private _remaining = floor (_count - _toRemove) max _minAmount;

    format ["Decaying item amount: %1, from %2 to %3", _item, _count, _remaining] call vgm_g_fnc_logInfo;

    for "_i" from 1 to (_count - _remaining) do {
        _unit removeItem _item;
    };

} forEach _itemCounts;


