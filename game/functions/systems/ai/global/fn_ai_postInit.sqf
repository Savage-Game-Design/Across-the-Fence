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

["btree_runner", vgm_g_fnc_ai_tickAllBehaviourTrees, [], 5] call para_g_fnc_scheduler_add_job;
