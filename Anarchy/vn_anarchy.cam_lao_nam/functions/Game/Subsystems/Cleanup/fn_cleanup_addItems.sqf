/*
 * File: fn_cleanup_addItems.sqf
 * Author: Spoffy
 * Description:
 *    Adds an item to the cleanup system. It'll be cleaned up when nobody is nearby.
 * Params:
 *    _item - Items to be cleaned up. Can be anything 'deleteVehicle' works on.
 * Returns:
 *    None
 * Example Usage:
 *    _unit call vn_mf_fnc_cleanup_addItems;
 */

params ["_item"];

//If we've been passed an array, rather than an item, add them all.
//More efficient than looping somewhere to add items.
if (_item isEqualType []) then {
	vn_mf_cleanup_items append _item;
} else {
	vn_mf_cleanup_items pushBack _item;
};
