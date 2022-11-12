/*
	File: fn_bf_veh_spawn_on_building_building_deleted.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Adds vehicle spawning actions to objects.

	Parameter(s):
		_building - Building whose objects have changed [NAMESPACE]
		_newObjects - New objects attached to the building [ARRAY]

	Returns:
		None

	Example(s):
		See building features config
*/

params ["_building", "_newObjects"];

//Remove any unnecessary blocking zones (e.g. from vehicle workshops that have decayed)
private _toDelete = [];
{
	if (_building inArea _x) {
		_toDelete pushBack _foreachindex;
	};
} forEach vn_mf_markers_blocked_areas;
{vn_mf_markers_blocked_areas deleteAt _x} forEach _toDelete;
publicVariable "vn_mf_markers_blocked_areas";
