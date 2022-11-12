/*
	File: fn_ai_delete_objective.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		This function should not be called outside of the AI subsystem.
		Delete an objective. Should only be called on objectives that have been 'finished'.

	Parameter(s):
		_objective - Objective to delete [Location]

	Returns: nothing

	Example(s): none
*/

//TODO - Maybe merge this with finish_objective?
params ["_objective"];

private _objectiveId = _objective getVariable "id";
private _objectiveType = _objective getVariable "type";

//Remove objective from index
missionNamespace setVariable [format ["para_s_ai_objective_%1", _objectiveId], nil];

//Remove objective from type list
private _objectiveList = missionNamespace getVariable [format ["para_s_ai_objectives_%1", _objectiveType], []];
private _index = _objectiveList find _objective;
if (_index > -1) then {
	_objectiveList deleteAt _index;
};

//Remove objective from global list
para_s_ai_obj_objectives = para_s_ai_obj_objectives - [_objective];
para_s_ai_obj_active_objectives = para_s_ai_obj_active_objectives - [_objective];

deleteVehicle _objective;