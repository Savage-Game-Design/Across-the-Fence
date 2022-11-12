/*
	File: fn_ai_subsystem_init.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Initialises the AI behaviour subsystem.

	Parameter(s): none

	Returns: nothing

	Example(s): nothing
*/

["behaviour_manager", para_g_fnc_ai_run_behaviours_all_groups, [], 3] call para_g_fnc_scheduler_add_job;