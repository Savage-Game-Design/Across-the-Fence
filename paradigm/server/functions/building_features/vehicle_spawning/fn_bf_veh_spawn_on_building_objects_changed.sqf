/*
	File: fn_bf_veh_spawn_on_building_objects_changed.sqf
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

{
	[[_x], "para_c_fnc_bf_veh_spawn_add_spawn_actions", 0, _x] call para_s_fnc_remoteExecCall_jip_obj_stacked;
} forEach _newObjects;
