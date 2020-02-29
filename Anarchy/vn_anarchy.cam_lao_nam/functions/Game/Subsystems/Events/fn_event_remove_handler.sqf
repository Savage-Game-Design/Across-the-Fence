/*
 * File: fn_event_addHandler.sqf
 * Author: Spoffy
 * Description:
 *    Adds a handler for a specific event. Keep these as efficient as possible.
 * Params:
 *    _eventName - Name of the event that will trigger the handler.
 *    _handler - Code to call when event fires
 * Returns:
 *    None
 * Example Usage:
 *    
 */

params ["_eventName", "_handler"];

private _handlerVar = format ["eventHandlers_%1", _eventName];

private _handlers =	missionNamespace getVariable [_handlerVar, []];
_handlers deleteAt (_handlers find _handler);