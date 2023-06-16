/*
    File: fn_event_triggerServer.sqf
    Author: Savage Game Design
    Date: 2022-11-20
    Last Update: 2023-05-07
    Public: Yes

    Description:
        Triggers the given event on the server.
        Optional data parameter is sent with the event to those clients.

    Parameter(s):
        _event - Triggering event. Can either be a string, or [event, topic] array, where event is a string, and topic is anything hashable. [STRING/ARRAY]
        _data - Optional data to send to the clients. This is passed to the callbacks. [ANY]

    Returns:
        Nothing

    Example(s):
        ["myCustomEvent", 3] call para_g_fnc_event_triggerServer;
        [["myCustomEvent", "ducks"], [getPlayerUID player]] call para_g_fnc_event_triggerServer;
 */

params ["_event", "_data"];

[clientOwner, _event, _data] remoteExecCall ["para_g_fnc_event_remoteExec_trigger", 2];


