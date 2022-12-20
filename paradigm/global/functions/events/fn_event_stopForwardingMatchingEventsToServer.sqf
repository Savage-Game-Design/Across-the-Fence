/*
    File: fn_event_stopForwardingMatchingEventsToServer.sqf
    Author:
    Date: 2022-11-27
    Last Update: 2022-12-20
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

params ["_hashableEvent"];

private _eventsToforward = localNamespace getVariable "para_event_eventsToForward";

_eventsToForward deleteAt _hashableEvent;
