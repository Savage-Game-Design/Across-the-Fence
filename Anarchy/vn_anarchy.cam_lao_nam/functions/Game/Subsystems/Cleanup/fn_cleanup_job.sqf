/*
 * File: fn_cleanup_job.sqf
 * Author: Spoffy
 * Description:
 *    A scheduled job that checks all grids that needs to be cleaned up, and cleans them up if nobody is nearby.
 * Params:
 *    None
 * Returns:
 *    None
 * Example Usage:
 *    Example usage goes here
 */

private _entitiesToClean = [];
private _nextCleanupItems = [];

{
	private _item = _x;
	if (playableUnits findIf {_x distance2d _item < vn_an_cleanup_minPlayerDistance} == -1) then {
		_entitiesToClean pushBack _item;
	} else {
		if !(isNull _item) then {
			_nextCleanupItems pushBack _item;
		};
	}
} forEach vn_an_cleanup_items;

vn_an_cleanup_items = _nextCleanupItems;

_entitiesToClean spawn {
	{
		deleteVehicle _x;
	} forEach _this;
};
