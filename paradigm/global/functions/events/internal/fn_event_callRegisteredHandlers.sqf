/*
    File: fn_event_callRegisteredHandlers.sqf
    Author: Savage Game Design
    Date: 2022-11-21
    Last Update: 2023-04-14
    Public: No

    Description:
        Calls the event handlers associated with the given event and origin machine.

    Parameter(s):
        _originMachineId - Machine ID of the client sending the event [NUMBER]
        _hashableEvent - Event to listen to, in the hashable format (string, string) [ARRAY]
        _originalEvent - Original event, before being converted to a hashable event [ARRAY]
        _data - Data sent with the event [ANY]

    Returns:
        Nothing

    Example(s):
        [2, ["eventName", hashValue objNull], ["eventName", objNull], _someData] call para_g_fnc_event_callRegisteredHandlers;
 */

params ["_originMachineId", "_hashableEvent", "_originalEvent", "_data"];

["DEBUG", format ["Calling handlers for %1 from %2", _originalEvent, _originMachineId]] call para_g_fnc_log;

private _eventListenersByOrigin = localNamespace getVariable "para_event_listenersByEventOrigin";
// This handles global listeners + general topic, due to the format the listeners are stored in.
// See attachHandler for more information.
private _handlerIdsToCall = flatten (_eventListenersByOrigin getOrDefault [_originMachineId, createHashMap] getOrDefault [_hashableEvent, []]);

[_handlerIdsToCall, _originMachineId, _originalEvent, _data] call para_g_fnc_event_callHandlersById;
