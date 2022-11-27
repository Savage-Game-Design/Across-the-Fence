/*
    File: fn_event_callRegisteredHandlers.sqf
    Author:
    Date: 2022-11-21
    Last Update: 2022-11-27
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

params ["_originMachineId", "_event", "_data"];

_event params ["_eventName", "_topic"];

private _eventListenersByOrigin = localNamespace getVariable "para_event_listenersByEventOrigin";

private _handlerIdsToCall = [];

// ====================
// Find all event handlers tied to this specific client origin.
// This handles local events.
// ====================
private _machineSpecificEventListenersByTopic = _eventListenersByOrigin
    getOrDefault [_originMachineId, createHashMap]
    getOrDefault [_eventName, createHashMap];

private _machineSpecificGeneralHandlerIds = _machineSpecificEventListenersByTopic getOrDefault ["", []];
private _machineSpecificTopicHandlerIds = _machineSpecificEventListenersByTopic getOrDefault [hashValue _topic, []];

_handlerIdsToCall = _handlerIdsToCall + _machineSpecificGeneralHandlerIds + _machineSpecificTopicHandlerIds;

// Locally relevant events are always registered as machine-specific
// Only need to process global events if we're getting an event from somewhere else
if (_originMachineId != clientOwner) then {
    // ====================
    // Find all global event handlers for this event
    // This is where the machine id is `0` or negative, e.g `-2`
    // ====================
    private _globalEventListenersByTopic = _eventListenersByOrigin
        getOrDefault [_originMachineId, createHashMap]
        getOrDefault [_eventName, createHashMap];

    private _globalGeneralHandlerIds = _globalEventListenersByTopic getOrDefault ["", []];
    private _globalTopicHandlerIds = _globalEventListenersByTopic getOrDefault [_topic, []];

    private _globalHandlerIds = _globalGeneralHandlerIds + _globalTopicHandlerIds;

    // Can ignore the exclusion list processing below if we've no global handlers.
    if (count _globalHandlerIds == 0) exitWith {};

    // ====================
    // Find all global event handlers we want to exclude when originating from this specific host
    // This is when we have machine ids like `-2` or `-5`.
    // ====================
    private _exclusionEventListenersByTopic = _eventListenersByOrigin
        getOrDefault [-_originMachineId, createHashMap]
        getOrDefault [_eventName, createHashMap];

    private _exclusionGeneralHandlerIds = _exclusionEventListenersByTopic getOrDefault ["", []];
    private _exclusionTopicHandlerIds = _exclusionEventListenersByTopic getOrDefault [_topic, []];
    private _exclusionHandlerIds = _exclusionGeneralHandlerIds + _exclusionTopicHandlerIds;

    // This is slow, try to avoid using exclusive machine ids like `-2` or `-5` or `-clientOwner`.
    // Can be optimised using an array if needed.
    if (count _exclusionHandlerIds > 0) then {
        _globalHandlerIds = _globalHandlerIds - _exclusionHandlerIds;
    };

    _handlerIdsToCall = _handlerIdsToCall + _globalHandlerIds;
};

[_handlerIdsToCall, _originMachineId, _event, _data] spawn para_g_fnc_event_callHandlersById;
