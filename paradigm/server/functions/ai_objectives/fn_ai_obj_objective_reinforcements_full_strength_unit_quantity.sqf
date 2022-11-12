/*
	File: fn_ai_obj_objective_reinforcements_full_strength_unit_quantity.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Returns the maximum number of units that an objective could have available, for the current number of players.
	
	Parameter(s):
		_objective - Objective to check reinforcements for [Object]
	
	Returns:
		Number of units the objective has available for reinforcements [Number]
	
	Example(s):
		[_nearestObjective] call para_s_fnc_ai_obj_objective_reinforcements_full_strength_unit_quantity
*/

params ["_objective"];

private _desiredSimultaneousUnitCount = [allPlayers, _objective getVariable "scaling_factor"] call para_g_fnc_ai_scale_to_player_count;

_desiredSimultaneousUnitCount * para_s_ai_obj_reinforcement_scaling * (_objective getVariable "reinforcements_factor") max 0