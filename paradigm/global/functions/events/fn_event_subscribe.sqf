/*
    File: fnc_event_subscribe.sqf
    Author: Savage Game Design
    Date: 2022-11-20
    Last Update: 2023-01-29
    Public: Yes

    Description:
        Causes the handler to be called, whenever the specified event fires on one of the provided clients.
        Event can be a string, or a combination of event and topic, where topic is anything hashable.
        - Just specifying an event means all events of that type are received
        - Specifying an event and topic, means only events with a matching topic will cause the callback to fire

        IMPORTANT:
            There's a delay between calling this, and the client receiving events from remote clients.
            I.e, not all events fired after calling this are guaranteed to trigger the callback.
            If you need that behaviour, consider using other systems.

            This does NOT apply to local events.
            Firing an event locally immediately after subscribing guarantees the callback will be called.


    Parameter(s):
        _clients - Where to listen for the event being fired from. Can be a number or networked object [ARRAY]
        _event - Event to listen to. Can either be a string, or [event, topic] array, where event is a string, and topic is anything hashable. [STRING/ARRAY]
        _handler - Callback to fire when one of the clients triggers the event. [CODE] or [parameters, code] [ARRAY]

    Returns:
        Handler ID, used to unsubscribe.

    Example(s):
        // Register to a local event
        [[clientOwner], "myCustomEvent", {}] call para_g_fnc_event_subscribe

        // Register to a local or server event, with a topic
        [[2, clientOwner], ["myCustomEvent", "ducks"], {}] call para_g_fnc_event_subscribe

        // Register to an event from any client, with a topic, and parameter for the callback
        [[0], ["myCustomEvent", player], [[32], {}]] call para_g_fnc_event_subscribe
 */

params [["_clients", [clientOwner]], "_event", "_handler"];

// Standardise event format
if !(_event isEqualType []) then {
    _event = [_event, ""];
};

// Standardise event handler format to [params, code]
if (_handler isEqualType {}) then {
    _handler = [[], _handler];
};

private _hashableEvent = [_event] call para_g_fnc_event_convertEventToHashableEvent;

_event params [["_eventName", nil, [""]], "_topic"];
private _topicString = _hashableEvent # 1;

private _handlerId = format ["%1_%2_%3", _eventName, _topicString, para_event_handlerCount];
para_event_handlerCount = para_event_handlerCount + 1;

// Log a warning if the event system is about to break, due to something bugging out and adding too many handlers
if (para_event_handlerCount > para_event_max_integer) then {
    ["WARNING", format ["Possible bug: more than %1 event handlers allocated", para_event_max_integer]] call para_g_fnc_log;
};

// Stages the handler, ready to be attached to an event.
// Allows the server to tell us to attach to the event, with the correct machine ids.
private _handlerCache = localNamespace getVariable "para_event_handlerCache";
_handlerCache set [_handlerId, _handler, true];

private _isTargetingLocalClient = {
       _x isEqualType objNull &&
        {
            local _x
        }
    || _x isEqualType 0 &&
        {
               _x isEqualTo 0
            || _x isEqualTo clientOwner
            || isServer && _x isEqualTo 2
            || _x < 0 && _x != -clientOwner
        }
};

private _isTargetingRemoteClient = {
       _x isEqualType objNull &&
        {
            !local _x
        }
    || _x isEqualType 0 &&
        {
               _x isEqualTo 0
            || (_x isNotEqualTo clientOwner)
            || isServer && (_x isNotEqualTo 2)
            || _x < 0
        }
};

private _shouldListenLocally = _clients findIf _isTargetingLocalClient > -1;
private _shouldListenRemotely = _clients findIf _isTargetingRemoteClient > -1;

["DEBUG", format ["New subscription to %1 on %2, with topic %3 (%4). Local: %5. Remote: %6", _eventName, _clients, _topic, _topicString, _shouldListenLocally, _shouldListenRemotely]] call para_g_fnc_log;

// Registering locally-relevant events as machine-specific events like this allows us to speed up local event triggering later
if (_shouldListenLocally) then {
    // Keep in cache if events need forwarding, so that the server can also add the handler later.
    private _keepHandlerInCache = _shouldListenRemotely;
    [[clientOwner], _hashableEvent, _event, _handlerId, _keepHandlerInCache] call para_g_fnc_event_attachHandler;
};

if (_shouldListenRemotely) then {
    [_clients, _event, _handlerId] remoteExec ["para_s_fnc_event_startForwardingMatchingEvents", 2];
};

_handlerId
