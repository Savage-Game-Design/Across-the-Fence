/*
	File: fn_fallthrough_checker_subsystem_init.sqf
	Author:  Savage Game Design
	Public: Yes

	Description:
		Initialises the world fallthrough checker, which attempts to repair or delete objects
		which fall out of the world.

	Parameter(s): none

	Returns: nothing

	Example(s):
		call para_g_fnc_fallthrough_checker_subsystem_init;
*/

// Format: [time to check, object, number of times checked]
fallthrough_checker_objects_to_check = [];
fallthrough_checker_check_delay = 20;

["fallthrough_checker", para_g_fnc_fallthrough_checker_job, [], 1] call para_g_fnc_scheduler_add_job;

localNamespace setVariable ["fallthrough_checker_initialized", true];