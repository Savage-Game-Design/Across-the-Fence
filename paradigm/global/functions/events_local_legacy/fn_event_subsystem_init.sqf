/*
	File: fn_event_subsystem_init.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Initialises the event subsystem.

	Parameter(s): none

	Returns: nothing

	Example(s):
		call para_g_fnc_event_subsystem_init;
*/

para_l_eventQueue = [];

["event_dispatcher", para_g_fnc_event_dispatcher_job, [], 1] call para_g_fnc_scheduler_add_job