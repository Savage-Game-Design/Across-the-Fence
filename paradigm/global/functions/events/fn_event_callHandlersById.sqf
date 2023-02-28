/*
    File: fn_event_callHandlersById.sqf
    Author: Savage Game Design
    Date: 2022-11-24
    Last Update: 2023-01-22
    Public: No

    Description:
        Calls the handlers with the specified IDs, passing them the given event, origin machine ID and event data.

    Parameter(s):
        _handlerIds - IDs of the existing handlers to call, as returned by subscribe [ANY]
        _originMachineId - Machine ID of the client the event is arriving from [NUMBER]
        _event - Event received. Should NOT be in the hashable form, as we want to use the original topic. [ARRAY]
        _data - Data sent with the event [ANY]

    Returns:
        Nothing

    Example(s):
        [[_registeredHandler], 2, ["eventName", objNull], 'ANYDATA'] call para_g_fnc_event_callHandlersById;
 */

params ["_handlerIds", "_originMachineId", "_event", "_data"];

_event params ["_eventName", "_topic"];

["DEBUG", format ["Calling handlers for %1 from %2, ids: %3", _event, _originMachineId, _handlerIds]] call para_g_fnc_log;

private _handlersByOrigin = localNamespace getVariable "para_event_handlersByOrigin";
private _handlersForThisOrigin = _handlersByOrigin getOrDefault [_originMachineId, createHashMap];
private _handlersForGlobalOrigin = _handlersByOrigin getOrDefault [0, createHashMap];

{
    private _handler =
        _handlersForThisOrigin getOrDefault [
            _x,
            _handlersForGlobalOrigin getOrDefault [
                _x,
                [[], {}, ""]
            ]
        ];
    _handler params ["_savedParameters", "_code"];
    [_data, _savedParameters, _eventName, _topic, _originMachineId] call _code;
} forEach _handlerIds;
