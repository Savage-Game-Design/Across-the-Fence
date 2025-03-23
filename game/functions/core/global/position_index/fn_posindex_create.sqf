/*
    File: fn_posindex_create.sqf
    Author: Savage Game Design
    Date: 2025-01-09
    Last Update: 2025-03-01
    Public: Yes

    Description:
        Creates a new position index, that finds items in a given area using inAreaArrayIndexes.
        Positions are cached to allow for fast searching, without re-generating the position array.

        This implementation takes an item, and uses a function to get its position.
        The position is cached in an array, so that `inAreaArrayIndexes` can be used for rapid searches.

        When an item is deleted, its index is put into a "vacant slots" pool, so that the next addition
        can re-use that array index.

        This approach ensures:
        - The index returned from _add is always valid. Any approach using `deleteAt` will break all stored indexes.
        - Constant time with the number of items when adding/deleting (although searching will take longer)

        This data structures exists to:
        - Avoid bugs in re-implementations of this functionality (as certain bugs could break the whole index)
        - Simplify working with mapped types (e.g - a hashmap with a position key)

    Parameter(s):
        _fnc_getItemPos - Converts an item into a position [CODE]
        _items - Initial items to seed the index with [ARRAY]

    Returns:
        Index [HASHMAP]

    Example(s):
        [
            { _this get "pos" },
            [ createHashMapFromArray [["pos", [0,0,0]]]]
        ] call vgm_g_fnc_posindex_create;

 */

params ["_fnc_getItemPos", ["_items", []]];

private _positions = [];
private _indexes = [];
// Shallow copy to avoid external systems interfering with our array
private _itemsCopy = [] + _items;
private _itemsMap = createHashMap;

{
    _positions pushBack (_x call _fnc_getItemPos);
    _indexes pushBack _forEachIndex;
    _itemsMap set [_forEachIndex, _x];
} forEach _itemsCopy;

private _posIndex = createHashMapFromArray [
    ["positions", _positions],
    ["items", _itemsCopy],
    // HashMaps can be sparse. Enables us to get all items without any nils.
    ["itemsMap", _itemsMap],
    ["vacantSlots", []],
    ["getItemPos", _fnc_getItemPos]
];

// Return the indexes of all added items for the caller to use
[_posIndex, _indexes]
