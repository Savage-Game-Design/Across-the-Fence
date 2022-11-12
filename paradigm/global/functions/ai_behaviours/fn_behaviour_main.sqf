/*
	File: fn_behaviour_main.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Run periodically to update behaviour of an AI group. This is the top-level behaviour, and should be the one run
		on each group.
	
	Parameter(s):
	   _group - Group to run the behaviour on
	
	Returns:
		Behaviour executed successfully [BOOL]
	
	Example(s):
		[_group] call para_g_fnc_behaviour_main;
 */

scopeName "behaviour";
params ["_group"];

if (!isNil "para_l_behaviour_debug") then {
	["VN AI Behaviour[%1]: Main Behaviour Execution", _group getVariable "behaviourId"] call BIS_fnc_logFormat;
};

//Update the AI's knowledge from global (i.e, server) sources.
_group call para_g_fnc_behaviour_update_ai_knowledge;

{
	if (vehicle _x == _x && assignedTarget _x isKindOf "Air") then {
		_x forgetTarget assignedTarget _x;
	};
} forEach units _group;

//If any other units have somehow claimed our vehicles, we'll unassign them to make sure our units dismount.
{
	private _vehicle = _x;
	if ([_vehicle, "claimedBy", [grpNull, 0]] call para_g_fnc_ai_public_var_get select 0 != _group) then {
		[_group, _vehicle] call para_g_fnc_behaviour_vehicle_unassign;
	} else {
		// Refresh our claim on the vehicle.
		[_vehicle, "claimedBy", [_group, serverTime + 10]] call para_g_fnc_ai_public_var_set;
	};
} forEach (_group getVariable ["behaviourAssignedVehicles", []]);

if (_group getVariable ["behaviourHoldingPos", false] || _group getVariable ["behaviourIdle", false]) then {
	[_group, getPos leader _group] call para_g_fnc_behaviour_assign_nearby_statics;
} else {
	//Make sure we aren't manning any statics if we're not defending.
	[_group] call para_g_fnc_behaviour_unassign_statics;
};

[_group] call para_g_fnc_behaviour_process_claimed_statics;

//Check if the group if is in combat, and run combat behaviours if so.
//This is priority 1, for optimal combat behaviour.
if (_group call para_g_fnc_behaviour_combat_check) exitWith {};

private _orders = _group getVariable ["orders", [""]];

private _orderType = _orders select 0;
private _orderParams = _orders select [1, count _orders];
private _actionType = _orderType;
private _actionParams = _orderParams;

//Translate defend order into other actions, based on the group's current knowledge.
//The group might patrol, or they might hold the point.
if (_orderType == "defend") then {
	_orderParams params ["_defendPos"];

	//If we're required to hold it for a minimum period of mine, then keep holding.
	private _mustHoldUntil = _group getVariable ["behaviourDefendMustHoldUntil", 0];
	if (serverTime < _mustHoldUntil) exitWith {
		_actionType = "hold";
		_actionParams = [_defendPos];
	};

	//If we're manning statics, we need to keep holding.
	if !(_group getVariable ["behaviourAssignedVehicles", []] select {_x isKindOf "StaticWeapon"} isEqualTo []) exitWith {
		_actionType = "hold";
		_actionParams = [_defendPos];
	};

	//If there's statics that need claiming, we should hold so we can claim them.
	if !([_group, _defendPos] call para_g_fnc_behaviour_get_unclaimed_statics isEqualTo []) exitWith {
		_actionType = "hold";
		_actionParams = [_defendPos];
	};

	//Patrolling: We alternate between patrol periods and rest periods.
	//Units patrol for a bit, then RTB, then patrol for a bit.
	//This gives us stable behaviour - the behaviours we're calling only change every few minutes.

	private _patrolDuration = _group getVariable "behaviourDefendPatrolDuration";
	private _patrolRestDuration = _group getVariable "behaviourDefendRestDuration";
	private _patrolLastStarted = _group getVariable ["behaviourDefendPatrolLastStarted", 0];
	private _timeSincePatrolStarted = serverTime - _patrolLastStarted;

	private _shouldPatrol = _timeSincePatrolStarted < _patrolDuration;

	if (_timeSincePatrolStarted > _patrolDuration + _patrolRestDuration) then {
		_group setVariable ["behaviourDefendPatrolLastStarted", serverTime];
		_shouldPatrol = true;
	};

	if (_shouldPatrol) then {
		//Arbitrary check for nearby roads - really, this check should be asking 'Am I in a town or village'.
		//Range is an approximation - ideally, it should be the maximum distance you can be from a road when inside a village.
		//Do a road patrol to make it seem more authentic in towns/cities.
		if !(_defendPos nearRoads 30 isEqualTo []) then {
			_actionType = "patrol_roads";
			_actionParams = [_defendPos, 150];
		} else {
			_actionType = "patrol";
			_actionParams = [_defendPos, 20 + random 80];
		};
	} else {
		//We're resting, just hold the point.
		_actionType = "hold";
		_actionParams = [_defendPos];
	};
};

private _actionBehaviourParams = [_group] + _actionParams;

//If holding, we don't want to charge off to fight other enemies.
if (_actionType == "hold") exitWith {
	_actionBehaviourParams call para_g_fnc_behaviour_hold;
};

//If we've got nearby enemy we know about, attack!
private _nearbyEnemyUnits = _group getVariable ["behaviourNearbyEnemyUnits", []];
if !(_nearbyEnemyUnits isEqualTo []) exitWith {
	//Take the first one for now, so we don't incur the cost of sorting by distance.
	[_group, getPos (_nearbyEnemyUnits # 0)] call para_g_fnc_behaviour_attack;
};

//If there is nearby combat, investigate. If we're investigating, don't run normal order code.
//TODO: We want to restrict this to not all units.
if (_group call para_g_fnc_behaviour_investigate_nearby_combat) exitWith {};

//TODO: Implement fall-through, so if a behaviour fails, we move to perform another one.
if (_actionType == "attack") exitWith {
	_actionBehaviourParams call para_g_fnc_behaviour_attack
};

if (_actionType == "pursue") exitWith {
	_actionBehaviourParams call para_g_fnc_behaviour_pursue
};

if (_actionType == "patrol") exitWith {
	_actionBehaviourParams call para_g_fnc_behaviour_patrol
};

if (_actionType == "patrol_points") exitWith {
	_actionBehaviourParams call para_g_fnc_behaviour_patrol_points
};

if (_actionType == "patrol_roads") exitWith {
	_actionBehaviourParams call para_g_fnc_behaviour_patrol_roads
};

if (_actionType == "ambush") exitWith {
	_actionBehaviourParams call para_g_fnc_behaviour_ambush
};

//Any other behaviour

true