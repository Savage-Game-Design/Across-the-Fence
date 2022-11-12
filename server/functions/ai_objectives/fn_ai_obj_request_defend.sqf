/*
    File: fn_ai_request_defend.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:
		Requests the AI subsystem send units to defend a location
    
    Parameter(s):
		_position - Location to defend, as a position AGL [ARRAY]
		_scalingFactor - How hard this objective should be, used to multiply unit quantities [NUMBER]
		_reinforcementsFactor - How many reinforcements should be available [NUMBER]
    
    Returns:
        Objective Created
    
    Example(s):
        [parameter] call vn_fnc_myFunction
*/

params ["_position", "_scalingFactor", ["_reinforcementsFactor", 1]];

/*
	Set up the objective
*/
private _objective = ["defend", _position] call para_s_fnc_ai_obj_create_objective;
_objective setVariable ["scaling_factor", _scalingFactor];
_objective setVariable ["reinforcements_factor", _reinforcementsFactor];
_objective setVariable ["squad_size", 4 + random 4];
_objective setVariable ["squad_type", "STANDARD"];

_objective setVariable ["onAssignScript", {
	params ["_objective", "_group"];

	_group setVariable ["orders", ["defend", getPos _objective], true];
}];

_objective