/*
	File: fn_ai_create_objective.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		This function should not be called outside of the AI subsystem.
		Creates a new objective with a unique id.

	Parameter(s):
		_type - Type of the objective [String]
		_position - Position of the objective [ARRAY]

	Returns:
		Objective [Location]

	Example(s):
		call para_s_fnc_ai_obj_create_objective;
*/

/*
	Standard fields on each objective:
		id: Unique id of the objective
		type: Type of the objective, such as 'patrol'
		assignedGroups: Groups assigned to the objective. 

    Optional:
	    onAssignScript - Fired when a squad is assigned to the objective
*/

params ["_type", "_position"];

private _objectiveId = para_s_ai_obj_objective_counter;
para_s_ai_obj_objective_counter = para_s_ai_obj_objective_counter + 1;

//We use a simple object, because having "getPos" available enables much faster algorithms.
private _objective = createSimpleObject ["a3\weapons_f\empty.p3d", AGLtoASL _position, true];
_objective setVariable ["entity_type", "objective"];
_objective setVariable ["id", _objectiveId];
_objective setVariable ["type", _type];
_objective setVariable ["assignedGroups", []];

//Default values for reinforcements
_objective setVariable ["squad_size", 4];
_objective setVariable ["squad_type", "STANDARD"];
_objective setVariable ["scaling_factor", 1];
_objective setVariable ["reinforcements_factor", 1];
_objective setVariable ["reinforcements_remaining", 1];
_objective setVariable ["spawned_units", []];

//Set up an index to retrieve the objective by id
missionNamespace setVariable [format ["para_s_ai_objective_%1", _objectiveId], _objective];

//Set up a list of objectives of the specific type
private _objectiveListKey = format ["para_s_ai_objectives_%1", _type];
private _objectiveList = missionNamespace getVariable [_objectiveListKey, []];
_objectiveList pushBack _objective;
missionNamespace setVariable [_objectiveListKey, _objectiveList];

para_s_ai_obj_objectives pushBack _objective;


_objective