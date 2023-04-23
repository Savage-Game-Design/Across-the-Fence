/*
    File: fn_event_startForwardingMatchingEventsToServer.sqf
    Author: Savage Game Design
    Date: 2022-11-27
    Last Update: 2023-01-22
    Public: No

    Description:
        Starts forwarding events from this machine to the server, if they match the given event name and topic.

    Parameter(s):
        _hashableEvents - Events to forward to the server, in a hashable format (string, string) [ARRAY]

    Returns:
        Nothing

    Example(s):
        [[["eventName", "myTopic"]]] remoteExec ["para_g_fnc_event_startForwardingMatchingEventsToServer", -2];
 */

params ["_hashableEvents"];

private _eventsToForward = localNamespace getVariable "para_event_eventsToForward";

// Allows forwarding table to be maintained even if event system hasn't been initialised yet.
if (isNil "_eventsToForward") then {
    _eventsToForward = createHashMap;
    localNamespace setVariable ["para_event_eventsToForward", _eventsToForward];
};

{
    _eventsToForward set [_x, true];
} forEach _hashableEvents;
