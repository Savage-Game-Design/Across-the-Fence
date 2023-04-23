/*
	File: fn_event_remove_handler.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Adds a handler for a specific event. Keep these as efficient as possible.

	Parameter(s):
		_eventName - Name of the event that will trigger the handler [String]
		_handler - Code to call when event fires [Code]

	Returns: nothing

	Example(s):
		["eventLoop", para_g_fnc_event_dispatcher_job, [], 5] call para_g_fnc_scheduler_add_job
*/

params ["_eventName", "_handler"];

private _handlerVar = format ["para_l_eventHandlers_%1", _eventName];

private _handlers =	missionNamespace getVariable [_handlerVar, []];
_handlers deleteAt (_handlers find _handler);