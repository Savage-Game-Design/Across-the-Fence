/*
	File: fn_loadbal_subsystem_init.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Initialises the load balancer subsystem.
		This subsystem distributes AI to clients to avoid overwhelming the server.
	
	Parameter(s): none
	
	Returns: nothing
	
	Example(s): none
*/

call para_s_fnc_loadbal_fps_aggregator;

["loadbal_fps_aggregator", {call para_s_fnc_loadbal_fps_aggregator}, [], 10] call para_g_fnc_scheduler_add_job;