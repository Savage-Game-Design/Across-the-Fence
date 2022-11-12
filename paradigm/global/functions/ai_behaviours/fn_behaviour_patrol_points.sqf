/*
    File: fn_behaviour_patrol_points.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        'Patrol' behaviour - has the AI group patrol along a specific set of points
    
    Parameter(s):
        _group - Group to apply the behaviour to. [GROUP]
		_points - Points to patrol. At least 2 *must* be provided [ARRAY]
		_loopFromStart - Whether go back to the start once points are done, or go back in reverse order. [BOOL]
    
    Returns:
        Behaviour executed successfully
    
    Example(s):
        [_group] call para_g_fnc_behaviour_patrol;
 */

params ["_group", "_points", ["_loopFromStart", false]];

if (!isNil "para_l_behaviour_debug") then {
	["VN AI Behaviour[%1]: Patrol Points Behaviour Execution - %2", _group getVariable "behaviourId", _this] call BIS_fnc_logFormat;
};

if (count _points < 2) exitWith {false};

if (speedMode _group != "LIMITED") then {
	_group setSpeedMode "LIMITED";
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

//How much to change the patrol point index by when a point is reached. Typically +1 or -1;
private _patrolPointIncrement = _group getVariable ["patrolPointIncrement", 1];
private _currentPatrolPointIndex = _group getVariable ["currentPatrolPointIndex", 0];
private _currentPatrolPoint = _points select _currentPatrolPointIndex;

//This logic is robust - because patrol_points might be called twice, with different values for _points.
//So we might suddenly be very far from the start or end of the array, and need to reset back to it.
if (leader _group distance2D _currentPatrolPoint < 5) then {
	private _nextIndex = _currentPatrolPointIndex + _patrolPointIncrement;
	//If we've run off the end of the patrol points
	if (_nextIndex >= count _points) then {
		//If we're supposed to start at the beginning, do so.
		if (_loopFromStart) exitWith {
			_patrolPointIncrement  = 1;
			_nextIndex = 1;
		};
		//Otherwise, we go backwards down the patrol points.
		_patrolPointIncrement = -1;
		//Subtract 2, because we want the second to last point.
		_nextIndex = count _points - 2;
	};

	//If we're before the start of the patrol points, go back to the start.
	if (_nextIndex < 0) then {
		_patrolPointIncrement = 1;
		_nextIndex = 1;
	};

	_currentPatrolPointIndex = _nextIndex;
	_currentPatrolPoint = _points select _currentPatrolPointIndex;
	_group setVariable ["currentPatrolPointIndex", _currentPatrolPointIndex];
	_group setVariable ["patrolPointIncrement", _patrolPointIncrement];
};

//This behaviour is smart, and won't add a new waypoint or update the position unnecessarily
[_group, "BEHAVIOUR_PATROL", "MOVE", AGLtoASL _currentPatrolPoint, -1] call para_g_fnc_behaviour_waypoint
