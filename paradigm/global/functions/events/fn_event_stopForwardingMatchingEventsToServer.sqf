/*
    File: fn_event_stopForwardingMatchingEventsToServer.sqf
    Author:
    Date: 2022-11-27
    Last Update: 2022-12-24
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

params ["_hashableEvents"];

private _eventsToForward = localNamespace getVariable "para_event_eventsToForward";

// Allows forwarding table to be maintained even if event system hasn't been initialised yet.
if (isNil "_eventsToForward") then {
    _eventsToForward = createHashMap;
    localNamespace setVariable ["para_event_eventsToForward", _eventsToForward];
};

{
    _eventsToForward deleteAt _x;
} forEach _hashableEvents;
