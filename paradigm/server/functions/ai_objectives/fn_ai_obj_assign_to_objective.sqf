/*
	File: fn_ai_assign_to_objective.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		This function should not be called outside of the AI subsystem.
		Assigns a group to an objective.

	Parameter(s):
		_group - Group to assign [Group]
		_objective - Objective to assign squad to [Location]

	Returns:
		true on success, false on failure [Boolean]

	Example(s): none
*/

params ["_group", "_objective"];

//["AI: Objective Assigned, Group with %1 units for [%2:%3]", count units _group, _objective getVariable "type", _objective getVariable "id"] call BIS_fnc_logFormat;

if (isNull _objective || _objective getVariable ["finished", false]) exitWith {};

private _assignedGroups = _objective getVariable "assignedGroups";
_assignedGroups pushBack _group;

_group setVariable ["objective", _objective];

[_objective, _group] call (_objective getVariable ["onAssignScript", {}]);

true
