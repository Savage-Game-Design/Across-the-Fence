/*
    File: fn_event_subscribeToClients.sqf
    Author: Savage Game Design
    Date: 2022-11-20
    Last Update: 2023-05-07
    Public: Yes

    Description:
        Causes the handler to be called, whenever specified event is received from one of the given clients.

        Event can be a string, or a combination of event and topic, where topic is anything hashable.
        - Just specifying an event means all events of that type are received
        - Specifying an event and topic, means only events with a matching topic will cause the callback to fire

        This immediately registers the handler, so that the next event received will invoke it.
        It's safe to assume that once this function has been called, all events emitted after this point will
        result in the handler being called.

    Parameter(s):
        _clients - Where to listen for the event being fired from. Must be a numerical machine id, e.g returned by clientOwner [ARRAY]
        _event - Event to listen to. Can either be a string, or [event, topic] array, where event is a string, and topic is anything hashable. [STRING/ARRAY]
        _handler - Callback to fire when one of the clients triggers the event. [CODE] or [parameters, code] [ARRAY]

    Returns:
        Handler ID, used to unsubscribe.

    Example(s):
        // Register to a local event
        [[clientOwner], "myCustomEvent", {}] call para_g_fnc_event_subscribeToClients

        // Register to a local or server event, with a topic
        [[2, clientOwner], ["myCustomEvent", "ducks"], {}] call para_g_fnc_event_subscribeToClients

        // Register to an event from any client, with a topic, and parameter for the callback
        [[0], ["myCustomEvent", player], [[32], {}]] call para_g_fnc_event_subscribeToClients
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

if !(_clients isEqualTypeAll 0) then {
    ["ERROR", format ["fn_event_subscribe only supports integer machine ids, given %1 instead", _clients]] call para_g_fnc_log;
    // Attempt to continue instead of aborting, in case it's just one bad value
    _clients = _clients select {_x isEqualType 0};
};

["DEBUG", format ["New subscription to %1 on %2, with topic %3 (%4).", _event # 0, _clients, _event # 1]] call para_g_fnc_log;

private _handlerId = [_clients, _event, _handler] call para_g_fnc_event_attachHandler;

_handlerId
