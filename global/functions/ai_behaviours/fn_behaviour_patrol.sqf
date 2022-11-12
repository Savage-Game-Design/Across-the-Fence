/*
	File: fn_behaviour_patrol.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		'Patrol' behaviour - has the AI group patrol around a point.
	
	Parameter(s):
		_group - Group to apply the behaviour to.
		_center - Center of the patrol area.
		_patrolRadius - Radius to patrol.
		_patrolAngleChange - Angle increments for the next patrol waypoint. IE, '30' is 30 degrees clockwise from the current point.
	
	Returns:
		Behaviour executed successfully
	
	Example(s):
		[_group] call para_g_fnc_behaviour_patrol;
 */

params ["_group", "_center", ["_patrolRadius", 0], ["_patrolAngleChange", 0]];

if (!isNil "para_l_behaviour_debug") then {
	["VN AI Behaviour[%1]: Patrol Behaviour Execution - %2", _group getVariable "behaviourId", _this] call BIS_fnc_logFormat;
};

//Too far away, we should move quickly to reach the patrol area.
private _desiredSpeedMode = "LIMITED";
if (leader _group distance2D _center > _patrolRadius * 1.25) then 
{
	_desiredSpeedMode = "FULL";
};
if (speedMode _group != _desiredSpeedMode) then {
	_group setSpeedMode _desiredSpeedMode;
};

if (combatMode _group != "RED") then {
	_group setCombatMode "RED";
};

if (behaviour leader _group != "SAFE") then {
	_group setBehaviour "SAFE";
};

if (formation _group != "COLUMN") then {
	_group setFormation "COLUMN";
};

[_group, "AUTO"] call para_g_fnc_behaviour_set_group_stance;

//This section exists to allow us to not specify _patrolAngleChange and _patrolRadius in the order.
if (_group getVariable ["defaultPatrolRadius", 0] == 0) then {
	_group setVariable ["defaultPatrolRadius",	50 + random 100];
};

if (_patrolRadius == 0) then {
	_patrolRadius = _group getVariable "defaultPatrolRadius";
};

if (_group getVariable ["defaultPatrolAngleChange", 0] == 0) then {
	_group setVariable ["defaultPatrolAngleChange", 30 * (selectRandom [1, -1])];
};

if (_patrolAngleChange == 0) then {
	_patrolAngleChange = _group getVariable "defaultPatrolAngleChange";
};

//If they've got nothing to do, give them something to do.
if (currentWaypoint _group == count waypoints _group || waypointType [_group, currentWaypoint _group] != "MOVE") then {
	private _nextDistance = _patrolRadius * (0.8 + random 0.2);
	private _nextAngle = (_center getDir getPos leader _group) + _patrolAngleChange;
	private _nextPosition = _center getPos [_nextDistance, _nextAngle];

	[_group, "BEHAVIOUR_PATROL", "MOVE", AGLtoASL _nextPosition, -1] call para_g_fnc_behaviour_waypoint;
};








