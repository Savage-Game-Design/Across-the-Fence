/*
	File: fn_event_dispatcher_job.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Fires queued events from the event loop.

	Parameter(s): none
	
	Returns: nothing

	Example(s):
		["eventLoop", para_g_fnc_event_dispatcher_job, [], 5] call para_g_fnc_scheduler_add_job
*/

//Event format
//[eventName: string, eventParameters: string]

{
	_x call para_g_fnc_event_fire;
} forEach para_l_eventQueue;

para_l_eventQueue = [];