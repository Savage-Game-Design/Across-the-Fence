/*
    File: fn_ai_obj_entity_killed_update_reinforcements.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        EntityKilled event handler, that depletes the remaining unit count for a given objective
		Specifically - reduces the overall % of units remaining in the objective.
    
    Parameter(s):
		_entity - Entity killed [Object]
		_killer - Entity that did the killing [Object]
		_instigator - Person who "pulled the trigger" [Object]
		_useEffects - Same as useEffects in setDamage alternative syntax [Boolean]
    
    Returns:
		none
    
    Example(s):
		addMissionEventHandler ["EntityKilled", para_s_fnc_ai_obj_entity_killed_update_reinforcements];
*/

params ["_entity", "_killer", "_instigator", "_useEffects"];

// Objective the unit was spawned for.
// Use this to enable strategies such as luring AI away from an objective then killing them.
// This might mean the AI gets a pursuit objective, but would still deplete the right objective's reinforcements.
private _objective = _entity getVariable "spawningObjective";

if (isNil "_objective") exitWith {};

_objective setVariable [
	"reinforcements_remaining", 
	(_objective getVariable ["reinforcements_remaining", 1]) - (1 / (_objective call para_s_fnc_ai_obj_objective_reinforcements_full_strength_unit_quantity)) max 0
];