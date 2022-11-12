/*
	File: fn_event_dispatch.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		[!:important] DO NOT ADD LONG RUNNING TASKS TO THIS QUEUE.
		Adds an event to the event queue.
		As it runs on the main scheduler, it will potentially blocks other aspects of the mission.

	Parameter(s): 
		_eventName - Name of the event to fire [STRING]
		_eventParams - Parameters to pass to event handler [ANY]
	
	Returns: nothing
	
	Example(s):
		["onTaskComplete", [_taskDataStore]] call para_g_fnc_event_dispatch;
*/

params ["_eventName", ["_eventParams", []]];

para_l_eventQueue pushBack [_eventName, _eventParams];