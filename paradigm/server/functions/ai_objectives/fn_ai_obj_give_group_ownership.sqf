/*
	File: fn_ai_give_group_ownership.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Gives the AI subsystem ownership of a group.
		Means the AI subsystem will handle cleanup of the group.

	Parameter(s):
		_groups - Array of groups [Group[]]

	Returns: nothing

	Example(s): none
*/

params ["_groups"];

if (_groups isEqualType grpNull) then { _groups = [_groups]; };

para_s_ai_obj_managedGroups append _groups;

{
	_x setVariable ["ownedBy", "AI subsystem"];
} forEach _groups;

//Enable behaviour handling for the groups
{
	_x setVariable ["behaviourEnabled", true, true];
} forEach _groups;