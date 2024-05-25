/*
    File: fn_event_subscribe.sqf
    Author: Savage Game Design
    Date: 2022-11-24
    Last Update: 2024-03-01
    Public: Yes

    Description:
        Identical behaviour to para_g_fnc_event_subscribeToClients, but fires when an event is received from any machine.

        Wrapper for para_g_fnc_event_subscribeToClients.


    Parameter(s):
        _event - Event to listen to. Can either be a string, or [event, topic] array, where event is a string, and topic is anything hashable. [STRING/ARRAY]
        _handler - Callback to fire when one of the clients triggers the event. [CODE] or [parameters, code] [ARRAY]

    Returns:
        Handler ID, used to unsubscribe.

    Example(s):
        // Register to a local event
        [ "myCustomEvent", {}] call para_g_fnc_event_subscribe

        // Register to local event, with a topic, and parameter for the callback
        [["myCustomEvent", player], [[32], {
            params ["_args", "_savedArgs", "_eventName", "_topic", "_originMachineId"];
        }]] call para_g_fnc_event_subscribe
 */

([[0]] + _this) call para_g_fnc_event_subscribeToClients;
