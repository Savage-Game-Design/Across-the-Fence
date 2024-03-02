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

#define CLEAN_MIN_DIST para_s_cleanup_minPlayerDistance
#define CLEAN_BODY_MIN_DIST para_s_cleanup_minPlayerBodyDistance

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
	_inPlayerRange append (para_s_cleanup_items_range_restricted inAreaArray [_x, CLEAN_MIN_DIST, CLEAN_MIN_DIST]);
} forEach allPlayers;

private _canDelete = para_s_cleanup_items_range_restricted - _inPlayerRange;
para_s_cleanup_items_range_restricted = para_s_cleanup_items_range_restricted - _canDelete;
para_s_cleanup_items_delete_immediately append _canDelete;

private _deadBodyOverrun = count para_s_cleanup_items_bodies - para_s_cleanup_max_bodies;
if (_deadBodyOverrun > 0) then {
    private _deletedBodiesIndices = [];
    {
        if (count (allPlayers inAreaArray [_x, CLEAN_BODY_MIN_DIST, CLEAN_BODY_MIN_DIST]) > 0) then {continue};
        if (count _deletedBodiesIndices >= _deadBodyOverrun) exitWith {};

        _deletedBodiesIndices pushBack _forEachIndex;
        para_s_cleanup_items_delete_immediately pushBack _x;
    } forEach para_s_cleanup_items_bodies;

    #if __GAME_VER_MIN__ >= 18
	para_s_cleanup_items_bodies deleteAt _deletedBodiesIndices;
    #else
    {para_s_cleanup_items_bodies deleteAt _x} forEach _deletedBodiesIndices;
    #endif
};

[] spawn {
	{
		deleteVehicle _x;
		sleep 0.02;
	} forEach para_s_cleanup_items_delete_immediately;
};
