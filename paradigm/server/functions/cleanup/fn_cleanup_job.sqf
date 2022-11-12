/*
	File: fn_cleanup_job.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		A scheduled job that checks all grids that needs to be cleaned up, and cleans them up if nobody is nearby.

	Parameter(s): nothing

	Returns: nothing

	Example(s): none
*/

para_s_cleanup_items_delete_immediately = para_s_cleanup_items_delete_immediately - [objNull];

// For every bucket that might have an item ready to be cleaned up
// add the items in those buckets to the detailed time check list
// and delete those buckets
// Reason: Optimisation to avoid checking every item
while {count para_s_cleanup_time_bucket_times > 0 && para_s_cleanup_time_bucket_times select 0 < time} do {
	private _key = para_s_cleanup_time_bucket_times deleteAt 0;
	para_s_cleanup_items_time_check append (
		para_s_cleanup_time_buckets get _key
	);
	para_s_cleanup_time_buckets deleteAt _key;
};

private _itemsPassingTimeCheck = para_s_cleanup_items_time_check select { _x getVariable "para_s_cleanup_earliest_time" < time };
para_s_cleanup_items_time_check = para_s_cleanup_items_time_check select { _x getVariable "para_s_cleanup_earliest_time" >= time };

private _newRangeRestrictedItems = _itemsPassingTimeCheck select {_x getVariable ["para_s_cleanup_range_restriction", false]};
para_s_cleanup_items_range_restricted append _newRangeRestrictedItems;
para_s_cleanup_items_delete_immediately append (_itemsPassingTimeCheck - _newRangeRestrictedItems);

private _inPlayerRange = [];
{
	_inPlayerRange append (para_s_cleanup_items_range_restricted inAreaArray [getPos _x, para_s_cleanup_minPlayerDistance, para_s_cleanup_minPlayerDistance]);
} forEach allPlayers;

private _canDelete = para_s_cleanup_items_range_restricted - _inPlayerRange;
para_s_cleanup_items_range_restricted = para_s_cleanup_items_range_restricted - _canDelete;
para_s_cleanup_items_delete_immediately append _canDelete;

private _deadBodyOverrun = count para_s_cleanup_items_bodies - para_s_cleanup_max_bodies;
if (_deadBodyOverrun > 0) then {
	para_s_cleanup_items_delete_immediately append (para_s_cleanup_items_bodies select [0, _deadBodyOverrun]);
	para_s_cleanup_items_bodies deleteRange [0, _deadBodyOverrun];
};

[] spawn {
	{
		deleteVehicle _x;
		sleep 0.02;
	} forEach para_s_cleanup_items_delete_immediately;
};