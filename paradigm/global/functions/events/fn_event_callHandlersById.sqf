/*
    File: fn_event_callHandlersById.sqf
    Author:
    Date: 2022-11-24
    Last Update: 2022-12-23
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
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
