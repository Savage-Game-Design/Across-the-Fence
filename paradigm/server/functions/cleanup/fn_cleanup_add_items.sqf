/*
	File: fn_cleanup_add_items.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Adds an item to the cleanup system. It'll be cleaned up when nobody is nearby.
	
	Parameter(s):
		_item - Items to be cleaned up. Can be anything 'deleteVehicle' works on [Array|Object]

	Returns: nothing

	Example(s):
		_unit call para_s_fnc_cleanup_add_items;
*/

params ["_items", ["_playerRangeRestriction", true], ["_minLifetime", -1]];

if !(_items isEqualType []) then {
	_items = [_items];
};

{
	_x setVariable ["para_s_cleanup_earliest_time", time + _minLifetime];
	_x setVariable ["para_s_cleanup_range_restriction", _playerRangeRestriction];
} forEach _items;

if (_minLifetime > para_s_cleanup_time_bucket_size) exitWith {
	private _bucketKey = floor ((time + _minLifetime) / para_s_cleanup_time_bucket_size) * para_s_cleanup_time_bucket_size;
	private _bucket = para_s_cleanup_time_buckets getOrDefault [_bucketKey, []];
	_bucket append _items;
	para_s_cleanup_time_buckets set [_bucketKey, _bucket];
	para_s_cleanup_time_bucket_times pushBackUnique _bucketKey;
};

if (_minLifetime > -1) exitWith {
	para_s_cleanup_items_time_check append _items;
};

if (_playerRangeRestriction) exitWith {
	para_s_cleanup_items_range_restricted append _items;
};

para_s_cleanup_items_delete_immediately append _items;		