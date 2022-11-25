/*
    File: fn_event_attachHandler.sqf
    Author:
    Date: 2022-11-21
    Last Update: 2022-11-25
    Public: No

    Description:
        Sets a handler to be called whenever an event is received from a specific machine, with an optional topic.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

params [["_machineIds", [clientOwner]], "_event", "_handlerId"];

_event params ["_eventName", "_topic"];

// Negative machine ids need to be registered to 0 (global) as well, as we treat negatives as "do not call" list.
private _hasNegative = _machineIds findIf {_x < 0} > -1;
if (_hasNegative) then {
    _machineIds pushBackUnique 0;
};

private _eventListenersByOrigin = localNamespace getVariable "para_event_listenersByEventOrigin";
private _handlerRegistrationPaths = localNamespace getVariable "para_event_handlerRegistrationPaths";

// TODO - Convert me to using hashvalue for event, with another hashmap for ids
{
    private _eventListenersByEventName = _eventListenersByOrigin getOrDefault [_x, createHashMap, true];
    private _eventListenersByTopic = _eventListenersByEventName getOrDefault [_eventName, createHashMap, true];
    private _eventListeners = _eventListenersByTopic getOrDefault [_topic, [], true];

    _eventListeners pushBackUnique _handlerId;

    // Register the handler path so we can remove it later without needing machineId/eventName/topic
    _handlerRegistrationPaths getOrDefault [_handlerId, [], true] pushBack [_x, _eventName, _topic];
} forEach _machineIds;
