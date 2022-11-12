/*
	File: fn_ai_request_attack.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Requests the AI subsystem send units to attack a location.

	Parameter(s):
		_position - Position to attack [ARRAY]
		_scalingFactor - How hard this objective should be, used to multiply unit quantities [NUMBER]
		_reinforcementsFactor - How many reinforcements should be available [NUMBER]

	Returns: nothing

	Example(s):
		call para_s_fnc_ai_obj_maintain_patrols;
*/

params ["_position", "_scalingFactor", ["_reinforcementsFactor", 1]];

/*
	Set up the objective
*/
private _objective = ["attack", _position] call para_s_fnc_ai_obj_create_objective;
_objective setVariable ["scaling_factor", _scalingFactor];
_objective setVariable ["reinforcements_factor", _reinforcementsFactor];
_objective setVariable ["squad_size", 8];
_objective setVariable ["squad_type", "STANDARD"];
_objective setVariable ["enabled_spawn_types", ["FOOT"]];

_objective setVariable ["onAssignScript", {
	params ["_objective", "_group"];

	_group setVariable ["orders", ["attack", getPos _objective], true];
}];

_objective