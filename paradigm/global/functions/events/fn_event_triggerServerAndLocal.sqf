/*
    File: fn_event_triggerServerAndLocal.sqf
    Author: Savage Game Design
    Date: 2022-11-20
    Last Update: 2025-02-06
    Public: Yes

    Description:
        Triggers the given event locally and on the server.
        Optional data parameter is sent with the event to those clients.

    Parameter(s):
        _event - Triggering event. Can either be a string, or [event, topic] array, where event is a string, and topic is anything hashable. [STRING/ARRAY]
        _data - Optional data to send to the clients. This is passed to the callbacks. [ANY]

    Returns:
        Nothing

    Example(s):
        ["myCustomEvent", 3] call para_g_fnc_event_triggerServerAndLocal;
        [["myCustomEvent", "ducks"], [getPlayerUID player]] call para_g_fnc_event_triggerServerAndLocal;
 */

params ["_event", "_data"];

if (!isServer) then {
    [clientOwner, _event, _data] remoteExecCall ["para_g_fnc_event_remoteExec_trigger", 2];
};

_this call para_g_fnc_event_triggerLocal;
