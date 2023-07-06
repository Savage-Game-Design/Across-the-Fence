/*
    File: fn_event_attachHandler.sqf
    Author: Savage Game Design
    Date: 2022-11-21
    Last Update: 2023-06-22
    Public: No

    Description:
        Sets a handler to be called whenever an event is received from a specific machine, with an optional topic.

    Parameter(s):
        _machineIds - Machine IDs of the clients we're listening to the events from [ARRAY]
        _event - Original event, before being converted to a hashable event [ARRAY]
        _handler - Callback to fire when one of the clients triggers the event. [parameters, code] [ARRAY]

    Returns:
        Nothing

    Example(s):
        [[1,2,3], _event, _handler] call para_g_fnc_event_attachHandler;
 */

params [["_machineIds", [clientOwner]], "_event", "_handler"];

// Safe to call, as it will only initialise once.
// Allows us to register handlers in preInit code, before the event system has initialised.
[] call para_g_fnc_event_system_init;

private _hashableEvent = [_event] call para_g_fnc_event_convertEventToHashableEvent;
_hashableEvent params ["_eventName", "_topicString"];

private _eventListenersByOrigin = localNamespace getVariable "para_event_listenersByEventOrigin";
private _handlerRegistrations = localNamespace getVariable "para_event_handlerRegistrations";
private _handlersByOrigin = localNamespace getVariable "para_event_handlersByOrigin";

// Generate a unique event handler ID
private _handlerId = format ["%1_%2_%3", _eventName, _topicString, para_event_handlerCount];
para_event_handlerCount = para_event_handlerCount + 1;

// Log a warning if the event system is about to break, due to something bugging out and adding too many handlers
if (para_event_handlerCount > para_event_max_integer) then {
    ["WARNING", format ["Possible bug: more than %1 event handlers allocated", para_event_max_integer]] call para_g_fnc_log;
};

// Store the handler for each origin, so it's dropped when all associated clients disconnect.
{
    _handlersByOrigin getOrDefault [abs _x, createHashMap, true] set [_handlerId, _handler];
} forEach _machineIds;

private _registrationsForThisHandler =
    _handlerRegistrations getOrDefault [_handlerId, [_hashableEvent, []], true];


/*
Listeners are stored in a 2-item array in this format:
    [
        listeners for this machine + topic,
        array reference to other listeners that need to be called
    ]
This allows for easy calling - flatten the array to get everything.
Using arrays by reference ensures everything is kept synchronised.

Rules:
1. Global listener, general topic - Calls only this
2. Global listener, specific topic - Calls this and 1
3. Machine-specific listener, general topic - Calls this, and 1
4. Machine specific listener, specific topic - calls this, 1, 2 and 3

*/

private _globalListeners = _eventListenersByOrigin getOrDefault [0, createHashMap, true];

// Every machine, general topic (i.e, all topics)
private _globalListenersForGeneralTopic = _globalListeners getOrDefault [
    [_eventName, ""],
    [[]],
    true
];

// Every machines, this topic.
// If the topic is general, just returns the entry above for the general topic which is guaranteed to be set.
// This avoids setting a bad value.
private _globalListenersForThisTopic = _globalListeners getOrDefault [
    _hashableEvent,
    [[], _globalListenersForGeneralTopic],
    true
];


{
    private _eventListenersForThisOrigin = _eventListenersByOrigin getOrDefault [_x, createHashMap, true];

    // Works even for origin 0 (global) and won't set a bad value, as it will fetch the value set above.
    private _originListenersForGeneralTopic = _eventListenersForThisOrigin getOrDefault [
        [_eventName, ""],
        [[], _globalListenersForGeneralTopic],
        true
    ];

    // Works even for origin 0 (global) and won't set a bad value, as it will fetch the value set above.
    // Else if the topic is general, just returns the entry above for the general topic which is guaranteed to be set.
    private _originListenersForThisTopic = _eventListenersForThisOrigin getOrDefault [
        _hashableEvent,
        [[], _originListenersForGeneralTopic # 0, _globalListenersForThisTopic],
        true
    ];


    (_originListenersForThisTopic # 0) pushBackUnique _handlerId;

    // Register the handler path so we can remove it later without needing machineId/eventName/topic
    _registrationsForThisHandler select 1 pushBack _x;
} forEach _machineIds;

_handlerId
