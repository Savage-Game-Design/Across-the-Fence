/*
    File: fnc_event_trigger.sqf
    Author: Savage Game Design
    Date: 2022-11-20
    Last Update: 2023-01-29
    Public: Yes

    Description:
        Triggers the given event on any client that's listening.
        Optional data parameter is sent with the event to those clients.

    Parameter(s):
        _event - Triggering event. Can either be a string, or [event, topic] array, where event is a string, and topic is anything hashable. [STRING/ARRAY]
        _data - Optional data to send to the clients. This is passed to the callbacks. [ANY]

    Returns:
        Nothing

    Example(s):
        ["myCustomEvent", 3] call para_g_fnc_event_trigger;
        [["myCustomEvent", "ducks"], [getPlayerUID player]] call para_g_fnc_event_trigger;
 */

params ["_event", "_data"];

// Standardise event format
if !(_event isEqualType []) then {
    _event = [_event, ""]
};

private _hashableEvent = [_event] call para_g_fnc_event_convertEventToHashableEvent;
private _generalEvent = [_event # 0, ""];

private _eventsToforward = localNamespace getVariable "para_event_eventsToForward";

// Forward event to server only if the client has been asked for it
if (_eventsToForward getOrDefault [_hashableEvent, false] || _eventsToForward getOrDefault [_generalEvent, false]) then {
    [_event, _data] remoteExec ["para_s_fnc_event_forward", 2];
};

// Call any local handlers
[clientOwner, _hashableEvent, _event, _data] call para_g_fnc_event_callRegisteredHandlers;

