/*
    File: fn_ai_obj_request_pursuit.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
		Requests the AI subsystem send units to pursue and engage a target.
    
    Parameter(s):
		_target - Target to pursue [OBJECT]
		_scalingFactor - How hard this objective should be, used to multiply unit quantities [NUMBER]
		_reinforcementsFactor - How many reinforcements should be available. 
		_side - Side to create pursuers on [SIDE]
    
    Returns:
		None
    
    Example(s):
		//TODO Example
*/

params ["_targets", "_scalingFactor", ["_reinforcementsFactor", 1], ["_side", east]];

/*
	Set up the objective
*/
private _objective = ["pursue", getPos (_targets select 0)] call para_s_fnc_ai_obj_create_objective;
_objective setVariable ["scaling_player_count_override", count _targets];
_objective setVariable ["scaling_factor", _scalingFactor];
_objective setVariable ["reinforcements_factor", _reinforcementsFactor];
_objective setVariable ["squad_size", 4];
_objective setVariable ["squad_type", "PATROL"];
_objective setVariable ["enabled_spawn_types", ["FOOT"]];

_objective setVariable ["onAssignScript", {
	params ["_objective", "_group"];

	["AI: Pursuit: Squad beginning pursuit %1m from target", getPos leader _group distance2D (_objective getVariable "targets" select 0)] call BIS_fnc_logFormat;

	//Set the group's orders.
	_group setVariable ["orders", ["pursue", _objective getVariable "targets" select 0], true];
}];

_objective setVariable ["targets", _targets];

_objective setVariable ["onTick", {
	params ["_objective"];
	private _lastTargetPos = getPos _objective;
	private _targets = _objective getVariable "targets" inAreaArray [_lastTargetPos, para_s_ai_obj_pursuitRadius, para_s_ai_obj_pursuitRadius] select {alive _x};

	//If we've lost the target, complete the pursuit.
	if (_targets isEqualTo []) exitWith {
		//No nearby players, finish the objective
		["AI: Pursuit: Objective [%1] lost target, completing objective", _objective getVariable "id"] call BIS_fnc_logFormat;
		//This WILL delete the objective
		[_objective] call para_s_fnc_ai_obj_finish_objective;
	};

	private _target = _targets select 0;
	
	//Update objective position to be on the target, so it stays active.
	_objective setPos getPos _target;

	//Unassign groups that are too far away from the objective.
	[
		(_objective getVariable "assignedGroups") select {leader _x distance2D _target > para_s_ai_obj_maxPursuitDistance},
		_objective
	] call para_s_fnc_ai_obj_unassign_from_objective;

	//Update squad targets
	{
		_x setVariable ["orders", ["pursue", _target], true];
	} forEach (_objective getVariable "assignedGroups");
}];

_objective

