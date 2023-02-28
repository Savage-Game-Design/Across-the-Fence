/*
    File: fn_event_stopForwardingMatchingEventsToServer.sqf
    Author: Savage Game Design
    Date: 2022-11-27
    Last Update: 2023-01-22
    Public: No

    Description:
        Stops forwarding any matching events to the server.

    Parameter(s):
        _hashableEvents - Events to forward to the server, in a hashable format (string, string) [ARRAY]

    Returns:
        Nothing

    Example(s):
        [[["eventName", "myTopic"]]] remoteExec ["para_g_fnc_event_stopForwardingMatchingEventsToServer", -2];
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
