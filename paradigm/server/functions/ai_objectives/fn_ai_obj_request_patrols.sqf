/*
    File: fn_ai_request_patrols.sqf
    Author:  Savage Game Design
    Description:
       Requests the AI subsystem station patrol units around an area
    Params:
		_type - Type of patrol [STRING]
		_patrolInfo - Info on the patrol as an [ARRAY]
			Either:
				_centerPosition - Position of area to patrol around
				_radius - Radius to patrol
			Or:
				[ARRAY] of points to patrol
		_scalingFactor - How hard this objective should be, used to multiply unit quantities [NUMBER]
		_reinforcementsFactor - How many reinforcements should be available [NUMBER]
    Returns:
       None
    Example Usage:
       [[{allPlayers}, 1], "circle", [0,0,0], 100] call para_s_fnc_ai_obj_request_patrols
       [[{allPlayers}, 1], "roads", [0,0,0], 100] call para_s_fnc_ai_obj_request_patrols
       [[{allPlayers}, 1], "points", [[0,0,0], [10,10,0],[20,20,0]]] call para_s_fnc_ai_obj_request_patrols
 */

params ["_type", "_patrolInfo", "_scalingFactor", ["_reinforcementsFactor", 1]];

["AI: Patrol Request: %1", _this] call BIS_fnc_logFormat;

//Orders to give to the AI
private _orders = [];

//Spawn position
private _spawnPosition = [];

if (_type == "circle") then {
	//Format: ["patrol", _center, _radius]
	_orders = ["patrol"] + _patrolInfo;
	_spawnPosition = _patrolInfo select 0;
};

if (_type == "points") then {
	//Format: ["patrol_points", _arrayOfPoints]
	_orders = ["patrol_points"] + _patrolInfo;
	_spawnPosition = _patrolInfo select 0 select 0;
};

if (_type == "roads") then {
	//Format: ["patrol_roads", _center, _radius]
	_orders = ["patrol_roads"] + _patrolInfo;
	_spawnPosition = _patrolInfo select 0;
};

/*
	Set up the objective
*/
private _objective = ["patrol", _spawnPosition] call para_s_fnc_ai_obj_create_objective;
_objective setVariable ["scaling_factor", _scalingFactor];
_objective setVariable ["reinforcements_factor", _reinforcementsFactor];
_objective setVariable ["squad_size", 4];
_objective setVariable ["squad_type", "PATROL"];

_objective setVariable ["orders", _orders];

_objective setVariable ["onAssignScript", {
	params ["_objective", "_group"];

	_group setVariable ["orders", _objective getVariable "orders", true];
}];

_objective