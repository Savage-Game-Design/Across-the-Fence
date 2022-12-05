/*
    File: fn_event_handlePlayerDisconnected.sqf
    Author:
    Date: 2022-12-05
    Last Update: 2022-12-05
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

params ["_disconnectedMachineId"];

private _eventListenersByOrigin = localNamespace getVariable "para_event_listenersByEventOrigin";
private _handlersByOrigin = localNamespace getVariable "para_event_handlersByOrigin";

_eventListenersByOrigin deleteAt _disconnectedMachineId;
_handlersByOrigin deleteAt _disconnectedMachineId;

// para_event_handlerRegistrations is cleaned up when the client unsubscribes
// and has minimal performance impact.

// para_event_eventsToForward is handled when an event is forwarded to the server
// that the server is no longer forwarding.
