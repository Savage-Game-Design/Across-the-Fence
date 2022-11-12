/*
    File: fn_create_or_reuse_waypoint.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Creates or repurposes a waypoint. To be used by scripts that create a lot of waypoints, but don't want to create hundreds.
		Tags each waypoint, to know whether it can be reused.
    
    Parameter(s):
		_group - group to add the waypoint to [Group]
		_tag - Tag for the waypoint to uniquely identify it [String]
		_center - Position for the waypoint if created [PositionAGL]
		_radius - Random placement radius for waypoint, or -1 for exact [Number]
		_tolerance - How far _center can be from the current waypoint before it's updated.
    
    Returns:
        [_group, _index] Waypoint [Array]
			_group - Group [Group]
			_index - Index [Number]
    
    Example(s):
        [_myGroup, "MOVETO_ATTACK", AGLtoASL [0,0,0], -1] call para_g_fnc_create_or_reuse_waypoint;
*/

params ["_group", "_tag", "_center", "_radius", ["_tolerance", 5]];

private _waypointToUse = [_group, count waypoints _group - 1];
//Count the waypoint number so we don't re-purpose their first waypoint, it glitches occasionally.
if (count waypoints _group > 1 && waypointName _waypointToUse isEqualTo _tag) then {
	//Only move the waypoint if the new one is at least _tolerance away.
	//Otherwise the AI will keep re-pathfinding.
	private _waypointPos = if (_radius == -1) then {AGLtoASL waypointPosition _waypointToUse} else {waypointPosition _waypointToUse};
	if (_center distance _waypointPos > _tolerance) then {
		_waypointToUse setWaypointPosition [_center, _radius];
	};
} else {
	_waypointToUse = _group addWaypoint [_center, _radius];
	_waypointToUse setWaypointName _tag;
};

_waypointToUse