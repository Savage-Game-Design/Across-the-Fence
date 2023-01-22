/*
	File: fn_event_dispatch.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		[!:important] Calls the event **immediately**. The main code will wait until all event code has finished executing.
		Immediately fires an event, without using the queue.

	Parameter(s): 
		_eventName - Name of the event to fire [STRING]
		_eventParams - Parameters to pass to event handler [ANY]
	
	Returns: nothing
	
	Example(s):
		["onTaskComplete", [_taskDataStore]] call para_g_fnc_event_dispatch_immediate;
*/

params ["_eventName", ["_eventParams", []]];

[_eventName, _eventParams] call para_g_fnc_event_fire;