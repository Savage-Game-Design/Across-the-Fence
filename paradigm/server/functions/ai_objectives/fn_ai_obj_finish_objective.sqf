/*
	File: fn_ai_finish_objective.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		This function should not be called outside of the AI subsystem.
		Should be called by anything making requests to the AI subsystem to clean up.

	Parameter(s):
		_objective - Objective, as an ID or a namespace [Number|Location]

	Returns: nothing

	Example(s): none
*/

params ["_objective"];

if (isNull _objective) exitWith {};

if (_objective isEqualType 0) then {
	_objective = _objective call para_s_fnc_ai_obj_get_objective_by_id;
};

//Call cleanup scripts.
//Note: It's possible for onDeactivation to be called twice back to back, in some instances, because of this.
//TODO - Combine some of this into an "deactivate_objective" function.
[_objective] call (_objective getVariable ["onDeactivation", {}]);
[_objective] call (_objective getVariable ["onFinish", {}]);

//Release AI, allowing them to be cleaned up if not in use.
private _assignedGroups = _objective getVariable "assignedGroups";
[_assignedGroups, _objective] call para_s_fnc_ai_obj_unassign_from_objective;

_objective setVariable ["finished", true];

[_objective] call para_s_fnc_ai_obj_delete_objective;