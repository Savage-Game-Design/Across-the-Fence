/*
    File: fn_event_subscribeLocal.sqf
    Author: Savage Game Design
    Date: 2022-11-24
    Last Update: 2023-01-29
    Public: Yes

    Description:
        Identical behaviour to para_g_fnc_event_subscribe, but only listens to local events.

        Wrapper for para_g_fnc_event_subscribe.


    Parameter(s):
        _event - Event to listen to. Can either be a string, or [event, topic] array, where event is a string, and topic is anything hashable. [STRING/ARRAY]
        _handler - Callback to fire when one of the clients triggers the event. [CODE] or [parameters, code] [ARRAY]

    Returns:
        Handler ID, used to unsubscribe.

    Example(s):
        // Register to a local event
        [ "myCustomEvent", {}] call para_g_fnc_event_subscribeLocal

        // Register to local event, with a topic, and parameter for the callback
        [["myCustomEvent", player], [[32], {}]] call para_g_fnc_event_subscribeLocal
 */

([[clientOwner]] + _this) call para_g_fnc_event_subscribe;
