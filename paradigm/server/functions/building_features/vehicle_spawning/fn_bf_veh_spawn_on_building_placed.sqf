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

private _arrayCount = count vn_mf_markers_blocked_areas + 1;
private _markerName = format ["blocked_area%1", _arrayCount];
while {(vn_mf_markers_blocked_areas find _markerName) != -1} do {
	_markerName = format ["%1%2", _markerName, _arrayCount];
};
private _adjustedPos = getPos _building;
_adjustedPos set [0, ((_adjustedPos select 0) + 2)];
_adjustedPos set [1, ((_adjustedPos select 1) + 3)];
private _marker = createMarkerLocal [_markerName, _adjustedPos];
_marker setMarkerSizeLocal [16.5, 7];
_marker setMarkerShapeLocal "RECTANGLE";
_marker setMarkerAlpha 0;
vn_mf_markers_blocked_areas pushBack _marker;
publicVariable "vn_mf_markers_blocked_areas";
