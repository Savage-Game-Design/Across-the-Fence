/*
    File: fnc_event_remoteExec_trigger.sqf
    Author: Savage Game Design
    Date: 2022-11-20
    Last Update: 2023-04-13
    Public: Yes

    Description:
        Remote executed from another clien to trigger the given event.
        Optional data parameter is sent with the event to those clients.

    Parameter(s):
        _originClient - Machine ID of the client sending the event. [NUMBER]
        _event - Triggering event. Can either be a string, or [event, topic] array, where event is a string, and topic is anything hashable. [STRING/ARRAY]
        _data - Optional data to send to the clients. This is passed to the callbacks. [ANY]

    Returns:
        Nothing

    Example(s):
        ["myCustomEvent", 3] call para_g_fnc_event_triggerLocal;
        [["myCustomEvent", "ducks"], [getPlayerUID player]] call para_g_fnc_event_triggerLocal;
 */

params ["_originClient", "_event", "_data"];

// Check the remote client isn't trying to pretend to be someone else, e.g the server.
if (!(remoteExecutedOwner in [0, 2]) && remoteExecutedOwner != _originClient) exitWith {
    [
        "WARNING",
        format ["Invalid remoteExecuted event trigger. Client %1 claimed to be client %2", remoteExecutedOwner, _originClient]
    ] call para_g_fnc_log;
};

// Standardise event format
if !(_event isEqualType []) then {
    _event = [_event, ""]
};

private _hashableEvent = [_event] call para_g_fnc_event_convertEventToHashableEvent;

[_originClient, _hashableEvent, _event, _data] call para_g_fnc_event_callRegisteredHandlers;
