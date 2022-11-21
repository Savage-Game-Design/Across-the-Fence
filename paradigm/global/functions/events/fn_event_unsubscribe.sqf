/*
    File: fnc_event_unsubscribe.sqf
    Author:
    Date: 2022-11-20
    Last Update: 2022-11-24
    Public: Yes

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

params ["_handlerId"];

private _handlerRegistrationPaths = localNamespace getVariable "para_event_handlerRegistrationPaths";
private _eventListenersByOrigin = localNamespace getVariable "para_event_listenersByEventOrigin";
private _allHandlers = localNamespace getVariable "para_event_handlers";

private _registeredPaths = _handlerRegistrationPaths getOrDefault [_handlerId, []];

{
    _x params ["_machineId", "_eventName", "_topic"];
    // This should be guaranteed by attachHandler to always be a valid path
    private _listeners = _eventListenersByOrigin get _machineId get _eventName get _topic;
    _listeners deleteAt (_listeners find _handlerId);
} forEach _registeredPaths;

_allHandlers deleteAt _handlerId;
