/*
    File: fnc_event_unsubscribe.sqf
    Author: Savage Game Design
    Date: 2022-11-20
    Last Update: 2023-04-14
    Public: Yes

    Description:
        Unsubscribes from the event associated with the given event handler id.

    Parameter(s):
        _handlerId - The handler ID returned by para_g_fnc_event_subscribeToClients and its variants. [STRING]

    Returns:
        Nothing

    Example(s):
        private _handlerId = [[2, clientOwner], "playerDied", para_g_fnc_handle_player_death] call para_g_fnc_event_subscribeToClients;
        [_handlerId] call para_g_fnc_event_unsubscribe;
 */

params ["_handlerId"];

private _handlerRegistrations = localNamespace getVariable "para_event_handlerRegistrations";
private _eventListenersByOrigin = localNamespace getVariable "para_event_listenersByEventOrigin";
private _handlersByOrigin = localNamespace getVariable "para_event_handlersByOrigin";

private _registration = _handlerRegistrations getOrDefault [_handlerId, []];
_registration params ["_hashableEvent", "_originMachineIds"];
_hashableEvent params ["_eventName", "_topicString"];

{
    private _machineId = _x;
    // Machine may already have been disconnected, so don't need to do anything.
    if !(_machineId in _eventListenersByOrigin) then { continue };
    // This should be guaranteed by attachHandler to always be a valid path
    private _listeners = _eventListenersByOrigin get _machineId get _hashableEvent select 0;
    // Edit the array in-place, as the whole system operates using references.
    _listeners deleteAt (_listeners find _handlerId);
    // Safe to delete since each handler should be mapped to a single event.
    _handlersByOrigin get _machineId deleteAt _handlerId;
} forEach _originMachineIds;

_handlerRegistrations deleteAt _handlerId;
