/*
	File: fn_behaviour_move_to.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		'Move To' behaviour - Has the AI move towards the point at the given speed.
	
	Parameter(s):
		_group - Group to apply the behaviour to. 
		_pos - Position to move to.
		_speedMode - Speed to move at.
		_completionDistance - How close the squad leader needs to be to the location to complete the move
	
	Returns:
		Group is at the position. <BOOL>
	
	Example(s):
		[_group, [10,10,10], "FULL", 15] call para_g_fnc_behaviour_move_to
 */


params ["_group", "_pos", ["_speedMode", ""], ["_completionDistance", 15]];


if (!isNil "para_l_behaviour_debug") then {
	["VN AI Behaviour[%1]: Move To Behaviour Execution - %2", _group getVariable "behaviourId", _this] call BIS_fnc_logFormat;
};

if (leader _group distance2D _pos <= _completionDistance) exitWith {
	true
};

//TODO - add padding here, so it's not constantly recalculating?
//Check if we've got a new position - so we can invalidate our cached data.
private _lastPos = _group getVariable ["behaviourMoveToLastPos", _pos];
if !(_lastPos isEqualTo _pos) then {
	_group setVariable ["behaviourMoveToRepairStrategy", 0];
	if (currentWaypoint _group > 0) then {
		deleteWaypoint [_group, currentWaypoint _group];
	};
};
_group setVariable ["behaviourMoveToLastPos", _pos];

//Set behaviour to AWARE, otherwise they might enter combat and grind to a halt.
//Maybe worth checking if speed is 'FULL'.
if (behaviour leader _group != "AWARE") then {
	_group setBehaviour "AWARE";
};

if (_speedMode != "" && {speedMode _group != _speedMode}) then {
	_group setSpeedMode _speedMode;
};

if (_speedMode == "FULL") then {
	//If we want to move at full speed, make sure they don't crawl.
	[_group, "AUTO"] call para_g_fnc_behaviour_set_group_stance;
};

private _wp = [_group, currentWaypoint _group];
//If we're moving somewhere, we don't need to do anything!
if (currentWaypoint _group <= count waypoints _group && waypointType _wp == "MOVE") exitWith {false};

//If we've completed all of our waypoints, and we've not exited this script because we're at our destination
//We've either: Never set off, or our waypoint broke (no path?)
//Run the 'repair state machine', a micro state machine with repair strategies.
private _repairStrategy = _group getVariable ["behaviourMoveToRepairStrategy", 0];

private _fnc_lastWaypointSuccessful = {
	private _lastWaypoint = waypoints _group select (currentWaypoint _group - 1);
	leader _group distance2D waypointPosition _lastWaypoint < 15
};

//Micro state-machine for repairing! 
private _repairStrategies = [
	//Strategy 0: Create a waypoint to the destination
	{
		[_group, "BEHAVIOUR_MOVE_TO", "MOVE", AGLtoASL _pos, -1] call para_g_fnc_behaviour_waypoint;
		//If we fail this, move to repair attempt 2.
		_repairStrategy = 1;
	},
	//Strategy 1: Move halfway towards the destination
	{
		private _distance = _pos distance2D getPos leader _group;
		private _newPos = leader _group getPos [_distance / 2, leader _group getDir _pos];
		[_group, "BEHAVIOUR_MOVE_TO", "MOVE", AGLtoASL _newPos, -1] call para_g_fnc_behaviour_waypoint;
		_repairStrategy = 2;
	},
	//Strategy 2: Direct move if last waypoint move was successful, else try a short hop forward
	{
		if (call _fnc_lastWaypointSuccessful) then {
			_repairStrategy = 0;
			call _fnc_performRepair;
		} else {
			_repairStrategy = 3;
			call _fnc_performRepair;
		};
	},
	//Strategy 3: A short move forward. 
	{
		private _newPos = leader _group getPos [15, (leader _group getDir _pos)];
		[_group, "BEHAVIOUR_MOVE_TO", "MOVE", AGLtoASL _newPos, -1] call para_g_fnc_behaviour_waypoint;
		_repairStrategy = 4;
	},
	//Strategy 4: Direct move if last waypoint move was successful, otherwises try a lateral movement.
	{
		if (call _fnc_lastWaypointSuccessful) then {
			_repairStrategy = 0;
			call _fnc_performRepair;
		} else {
			_repairStrategy = 5;
			call _fnc_performRepair;
		};
	},
	//Strategy 5: A short move sideways. 
	{
		private _newPos = leader _group getPos [15, (leader _group getDir _pos) + 90];
		[_group, "BEHAVIOUR_MOVE_TO", "MOVE", AGLtoASL _newPos, -1] call para_g_fnc_behaviour_waypoint;
		_repairStrategy = 4;
	},
	//Strategy 6: Direct move if last waypoint move was successful, otherwise attempt a teleport.
	{
		if (call _fnc_lastWaypointSuccessful) then {
			_repairStrategy = 0;
			call _fnc_performRepair;
		} else {
			_repairStrategy = 7;
			call _fnc_performRepair;
		};
	},
	//Strategy 7: Teleport when no players are nearby. handles AI stuck in objects.
	{
		diag_log "VN MikeForce: Group %1 is *very* stuck, attempting teleport.";
		if (allPlayers inAreaArray [getPos leader _group, 300, 300] isEqualTo []) then {
			diag_log "VN MikeForce: Group %1 is *very* stuck, teleporting them now.";
			private _newPos = leader _group getPos [20 + random 20, random 360];
			{
				_x setPos _newPos;
			} forEach units _group;
			_repairStrategy = 1;
			call _fnc_performRepair;
		};
	}
];

private _fnc_performRepair = {
	call (_repairStrategies select _repairStrategy)
};

call _fnc_performRepair;

_group setVariable ["behaviourMoveToRepairStrategy", _repairStrategy];

false