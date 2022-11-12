/*
	File: fn_ai_unassign_from_objective.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Unassigns a squad from an objective.

	Parameter(s):
		_group - Group to unassign [Group]
		_objective - Objective to unassign from [Location

	Returns: nothing

	Example(s): nothing
*/

params ["_groups", "_objective"];

if (_groups isEqualType grpNull) then {
	_groups = [_groups];
};

private _assignedGroups = _objective getVariable ["assignedGroups", []];
_objective setVariable ["assignedGroups", _assignedGroups - _groups];

{
	_x setVariable ["objective", nil];
} forEach _groups;