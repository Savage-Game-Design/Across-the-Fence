
/*
    File: fn_behaviour_pursue.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        When called on a group, gives them a waypoint of X type, and makes sure they're following it.
		Manual waypoint handling may still be needed if you need to do more complex actions, such as trigger scripts on waypoint completion.
    
    Parameter(s):
        _group - Group to perform this behaviour. [GROUP]
		_tag - Unique tag for the waypoint. If the last waypoint has the same tag, it will be reused. [STRING]
		_waypointType - Type of waypoint to use [STRING]
		_position - Position of the waypoint [ARRAY]
		_radius - Radius to place the waypoint in [NUMBER, defaults to -1]
        _tolerance - How much the waypoint can vary by, before being updated [NUMBER, defaults to 5]
    
    Returns:
        Waypoint if behaviour executed successfully, otherwise [] [ARRAY]
    
    Example(s):
        [_group, "BEHAVIOUR_TEST_DOTHING", "SAD", [0,0,0], -1] call para_g_fnc_behaviour_waypoint
 */

params ["_group", "_tag", "_type", "_position", ["_radius", -1], ["_tolerance", 5]];

if (!isNil "para_l_behaviour_debug") then {
	["VN AI Behaviour[%1]: Waypoint Behaviour Execution - %2", _group getVariable "behaviourId", _this] call BIS_fnc_logFormat;
};

private _waypoint = [_group, _tag, _position, _radius, _tolerance] call para_g_fnc_create_or_reuse_waypoint;
if (_waypoint select 1 != currentWaypoint _group) then {
	_group setCurrentWaypoint _waypoint;
};

if (waypointType _waypoint != _type) then {
	_waypoint setWaypointType _type;
};

_waypoint
