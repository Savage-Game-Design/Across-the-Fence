/*
    File: fn_event_handlePlayerDisconnected.sqf
    Author: Savage Game Design
    Date: 2022-12-05
    Last Update: 2023-01-22
    Public: No

    Description:
        Called on clients when a player disconnects, to clear out anything associated with their machine ID on this client.

    Parameter(s):
        _disconnectedMachineId - Machine ID of the disconnected player [NUMBER]

    Returns:
        Nothing

    Example(s):
        [36] call para_g_fnc_event_handlePlayerDisconnected;
 */

params ["_disconnectedMachineId"];

private _eventListenersByOrigin = localNamespace getVariable "para_event_listenersByEventOrigin";
private _handlersByOrigin = localNamespace getVariable "para_event_handlersByOrigin";

_eventListenersByOrigin deleteAt _disconnectedMachineId;
_handlersByOrigin deleteAt _disconnectedMachineId;

// para_event_handlerRegistrations is cleaned up when the client unsubscribes
// and has minimal performance impact.

// para_event_eventsToForward is handled when an event is forwarded to the server
// that the server is no longer forwarding.
