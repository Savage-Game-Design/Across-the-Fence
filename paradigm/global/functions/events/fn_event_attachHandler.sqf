/*
    File: fn_event_attachHandler.sqf
    Author: Savage Game Design
    Date: 2022-11-21
    Last Update: 2023-01-22
    Public: No

    Description:
        Sets a handler to be called whenever an event is received from a specific machine, with an optional topic.

    Parameter(s):
        _machineIds - Machine IDs of the clients we're listening to the events from [ARRAY]
        _hashableEvent - Event to listen to, in the hashable format (string, string) [ARRAY]
        _originalEvent - Original event, before being converted to a hashable event [ARRAY]
        _handlerId - Unique ID of the callback to call when the event is received [ANY]
        _keepHandlerInCache - Whether or not to remove the handler from the handler cache when we attach it. Should be false, unless handler needs to be added multiple times. [BOOL]

    Returns:
        Nothing

    Example(s):
        private _hashableEvent = [_event] call para_g_fnc_event_convertEventToHashableEvent;
        [[1,2,3], _hashableEvent, _event, _handlerId] call para_g_fnc_event_attachHandler;
 */

params [["_machineIds", [clientOwner]], "_hashableEvent", "_originalEvent", "_handlerId", ["_keepHandlerInCache", false]];

_hashableEvent params ["_eventName", "_topicString"];

// Negative machine ids need to be registered to 0 (global) as well, as we treat negatives as "do not call" list.
private _hasNegative = _machineIds findIf {_x < 0} > -1;
if (_hasNegative) then {
    _machineIds pushBackUnique 0;
};

private _eventListenersByOrigin = localNamespace getVariable "para_event_listenersByEventOrigin";
private _handlerRegistrations = localNamespace getVariable "para_event_handlerRegistrations";
private _handlerCache = localNamespace getVariable "para_event_handlerCache";
private _handlersByOrigin = localNamespace getVariable "para_event_handlersByOrigin";

private _handler = _handlerCache get _handlerId;
if (isNil "_handler") exitWith {
    // Handles the situation where an event has been unsubscribed
    // before the server has told the client to attach the handler.
    ["INFO", format ["Unable to attach handler %1 for event %2 listening to %3, not found in cache", _handlerId, _event, _machineIds]] call para_g_fnc_log;
};

// Cache is a temporary staging area - it shouldn't build up over time.
// In some circumstances need to avoid removing handler, so it can be attached by something else later as well.
if (!_keepHandlerInCache) then {
    _handlerCache deleteAt _handlerId;
};

{
    _handlersByOrigin getOrDefault [abs _x, createHashMap, true] set [_handlerId, _handler];
} forEach _machineIds;

{
    private _eventListenersByEventName = _eventListenersByOrigin getOrDefault [_x, createHashMap, true];
    private _eventListenersByTopic = _eventListenersByEventName getOrDefault [_eventName, createHashMap, true];
    private _eventListeners = _eventListenersByTopic getOrDefault [_topicString, [], true];

    _eventListeners pushBackUnique _handlerId;

    // Register the handler path so we can remove it later without needing machineId/eventName/topic
    _handlerRegistrations getOrDefault [_handlerId, [_originalEvent, []], true] select 1 pushBack _x;
} forEach _machineIds;
