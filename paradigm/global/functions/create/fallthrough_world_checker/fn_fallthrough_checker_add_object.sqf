/*
	File: fn_fallthrough_checker_add_object.sqf
	Author:  Savage Game Design
	Public: Yes

	Description:
		Adds an object to the fallthrough world checker, to be checked at a future time.

	Parameter(s): 
		None

	Returns:
		Nothing

	Example(s):
		[_object] call para_g_fnc_fallthrough_checker_add_object;

*/

params ["_object", ["_numberOfTimesCheckedPreviously", 0]];

fallthrough_checker_objects_to_check pushBack [
	time + fallthrough_checker_check_delay,
	_object,
	_numberOfTimesCheckedPreviously
];