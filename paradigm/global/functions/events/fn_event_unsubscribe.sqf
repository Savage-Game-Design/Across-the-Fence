/*
    File: fnc_event_unsubscribe.sqf
    Author:
    Date: 2022-11-20
    Last Update: 2022-12-20
    Public: Yes

    Description:
        Unsubscribes from the event associated with the given event handler id.

    Parameter(s):
        _handlerId - The handler ID returned by para_g_fnc_event_subscribe and its variants. [STRING]

    Returns:
        Nothing

    Example(s):
        private _handlerId = [[2, clientOwner], "playerDied", para_g_fnc_handle_player_death] call para_g_fnc_event_subscribe;
        [_handlerId] call para_g_fnc_event_unsubscribe;
 */

params ["_handlerId"];

private _handlerRegistrations = localNamespace getVariable "para_event_handlerRegistrations";
private _eventListenersByOrigin = localNamespace getVariable "para_event_listenersByEventOrigin";
private _handlersByOrigin = localNamespace getVariable "para_event_handlersByOrigin";
private _handlerCache = localNamespace getVariable "para_event_handlerCache";

private _registration = _handlerRegistrations getOrDefault [_handlerId, []];
_registration params ["_event", "_originMachineIds"];
private _hashableEvent = [_event] call para_g_fnc_event_convertEventToHashableEvent;
_hashableEvent params ["_eventName", "_topicString"];

private _machineIdsToStopForwarding = [];

// Prevents any forwarding requests that may already be in flight re-attaching the handler.
_handlerCache deleteAt _handlerId;

{
    private _machineId = _x;
    // Machine may already have been disconnected, so don't need to do anything.
    if !(_machineId in _eventListenersByOrigin) then { continue };
    // This should be guaranteed by attachHandler to always be a valid path
    private _listeners = _eventListenersByOrigin get _machineId get _eventName get _topicString;
    _listeners deleteAt (_listeners find _handlerId);
    // If client is not listening to this event from this machine now, tell server to stop forwarding it.
    if (_listeners isEqualTo []) then {
        _machineIdsToStopForwarding pushBack _machineId;
    };
    // Safe to delete since each handler should be mapped to a single event.
    _handlersByOrigin get _machineId deleteAt _handlerId;
} forEach _originMachineIds;


if !(_machineIdsToStopForwarding isEqualTo []) then {
    [_machineIdsToStopForwarding, _event] remoteExec ["para_s_fnc_event_stopForwardingMatchingEvents", 2];
};
