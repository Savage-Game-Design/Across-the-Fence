/*
    File: fn_event_subscribeServer.sqf
    Author: Savage Game Design
    Date: 2022-11-24
    Last Update: 2023-04-07
    Public: Yes

    Description:
        Identical behaviour to para_g_fnc_event_subscribeToClients, but only listens to server events.

        Wrapper for para_g_fnc_event_subscribeToClients.


    Parameter(s):
        _event - Event to listen to. Can either be a string, or [event, topic] array, where event is a string, and topic is anything hashable. [STRING/ARRAY]
        _handler - Callback to fire when one of the clients triggers the event. [CODE] or [parameters, code] [ARRAY]

    Returns:
        Handler ID, used to unsubscribe.

    Example(s):
        // Register to a server event
        [ "myCustomEvent", {}] call para_g_fnc_event_subscribeServer

        // Register to server event, with a topic, and parameter for the callback
        [["myCustomEvent", player], [[32], {}]] call para_g_fnc_event_subscribeServer
 */

([[2]] + _this) call para_g_fnc_event_subscribeToClients;
