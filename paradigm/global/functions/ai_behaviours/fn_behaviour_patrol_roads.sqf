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

scopeName "patrol_roads";

params ["_group", "_position", ["_range", 150]];

if (!isNil "para_l_behaviour_debug") then {
	["VN AI Behaviour[%1]: Patrol Points Behaviour Execution - %2", _group getVariable "behaviourId", _this] call BIS_fnc_logFormat;
};

private _desiredSpeedMode = "LIMITED"; 
//Too far away, we should move quickly to reach the patrol area.
if (leader _group distance2D _position > _range * 1.25) then 
{
	_desiredSpeedMode = "FULL";
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

private _currentRoad = _group getVariable ["patrolCurrentRoad", objNull];

//If they haven't got a current road to patrol, or the road is too far from where they're supposed to be.
if (isNull _currentRoad || _currentRoad distance2D _position > _range) then {
	private _nearbyRoads = _position nearRoads (50 min _range);
	if (_nearbyRoads isEqualTo []) then {
		false breakOut "patrol_roads";
	};
	_currentRoad = selectRandom _nearbyRoads;
	_group setVariable ["patrolCurrentRoad", _currentRoad];
};

if (leader _group distance2D _currentRoad < 10) then {
	private _connectedRoads = roadsConnectedTo _currentRoad;


	_connectedRoads = _connectedRoads select {_x distance2D _position < _range};

	if (count _connectedRoads >= 2) then {
		_connectedRoads = _connectedRoads - [_group getVariable ["patrolLastRoad", objNull]];
	};	

	if (_connectedRoads isEqualTo []) then {
		false breakOut "patrol_roads";
	};

	_group setVariable ["patrolLastRoad", _currentRoad];
	_currentRoad = selectRandom _connectedRoads;
	_group setVariable ["patrolCurrentRoad", _currentRoad];
};

//This behaviour is smart, and won't add a new waypoint or update the position unnecessarily
[_group, getPos _currentRoad , _desiredSpeedMode] call para_g_fnc_behaviour_move_to;
