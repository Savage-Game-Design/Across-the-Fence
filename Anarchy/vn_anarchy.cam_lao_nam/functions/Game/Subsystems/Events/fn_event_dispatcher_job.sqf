/*
 * File: fn_event_job.sqf
 * Author: Spoffy
 * Description:
 *    Fires queued events from the event loop.
 * Params:
 *    None
 * Returns:
 *    None
 * Example Usage:
 * 	 ["eventLoop", vn_mf_fnc_event_dispatcher_job, [], 5] call vn_mf_fnc_scheduler_add_job
 */

//Event format
//[eventName: string, eventParameters: string]

{
	_x params ["_eventName", "_eventParameters"];
	private _handlers =	missionNamespace getVariable [format ["eventHandlers_%1", _eventName], []];

	{
		_eventParameters call _x;
	} forEach _handlers;
} forEach vn_mf_eventQueue;

vn_mf_eventQueue = [];