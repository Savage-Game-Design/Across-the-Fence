/*
    File: fn_event_startForwardingMatchingEventsToServer.sqf
    Author:
    Date: 2022-11-27
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

params ["_event"];

private _eventsToforward = localNamespace getVariable "para_event_eventsToForward";
private _eventHash = hashValue _event;

_eventsToForward deleteAt _eventHash;
