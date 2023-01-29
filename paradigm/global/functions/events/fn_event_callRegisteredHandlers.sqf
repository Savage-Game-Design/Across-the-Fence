/*
    File: fn_event_callRegisteredHandlers.sqf
    Author: Savage Game Design
    Date: 2022-11-21
    Last Update: 2023-01-22
    Public: No

    Description:
        Calls the event handlers associated with the given event and origin machine.

    Parameter(s):
        _originMachineId - Machine ID of the client sending the event [NUMBER]
        _hashableEvent - Event to listen to, in the hashable format (string, string) [ARRAY]
        _originalEvent - Original event, before being converted to a hashable event [ARRAY]
        _data - Data sent with the event [ANY]

    Returns:
        Nothing

    Example(s):
        [2, ["eventName", hashValue objNull], ["eventName", objNull], _someData] call para_g_fnc_event_callRegisteredHandlers;
 */

params ["_originMachineId", "_hashableEvent", "_originalEvent", "_data"];

["DEBUG", format ["Calling handlers for %1 from %2", _originalEvent, _originMachineId]] call para_g_fnc_log;

_hashableEvent params ["_eventName", "_topicString"];

private _eventListenersByOrigin = localNamespace getVariable "para_event_listenersByEventOrigin";

private _handlerIdsToCall = [];

private _globalTopic = "";

// ====================
// Find all event handlers tied to this specific client origin.
// This handles local events.
// ====================
private _machineSpecificEventListenersByTopic = _eventListenersByOrigin
    getOrDefault [_originMachineId, createHashMap]
    getOrDefault [_eventName, createHashMap];

private _handlerIdsToCall = _machineSpecificEventListenersByTopic getOrDefault [_globalTopic, []];

if (_topicString isNotEqualTo _globalTopic) then {
    _handlerIdsToCall = _handlerIdsToCall + (_machineSpecificEventListenersByTopic getOrDefault [_topicString, []]);
};

// Locally relevant events are always registered as machine-specific
// Only need to process global events if we're getting an event from somewhere else
if (_originMachineId != clientOwner) then {
    // ====================
    // Find all global event handlers for this event
    // This is where the machine id is `0`
    // ====================
    private _globalEventListenersByTopic = _eventListenersByOrigin
        getOrDefault [0, createHashMap]
        getOrDefault [_eventName, createHashMap];

    _handlerIdsToCall = _handlerIdsToCall + (_globalEventListenersByTopic getOrDefault [_globalTopic, []]);

    if (_topicString isNotEqualTo _globalTopic) then {
       _handlerIdsToCall = _handlerIdsToCall + (_globalEventListenersByTopic getOrDefault [_topicString, []]);
    };
};

[_handlerIdsToCall, _originMachineId, _originalEvent, _data] spawn para_g_fnc_event_callHandlersById;
