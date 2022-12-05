/*
    File: fnc_event_unsubscribe.sqf
    Author:
    Date: 2022-11-20
    Last Update: 2022-12-04
    Public: Yes

    Description:
        Unsubscribes from the event associated with the given event handler id.

    Parameter(s):
        _handlerId - The handler ID returned by para_g_fnc_event_subscribe and its variants. [STRING]

    Returns:
        Nothing

    Example(s):
        private _handlerId = [[2, clientOwner], "playerDied", para_g_fnc_handle_player_death] call para_g_fnc_event_subscribe;
        [_handlerId] call para_g_fnc_event_unsubscribe;
 */

params ["_handlerId"];

private _handlerRegistrations = localNamespace getVariable "para_event_handlerRegistrations";
private _eventListenersByOrigin = localNamespace getVariable "para_event_listenersByEventOrigin";
private _allHandlers = localNamespace getVariable "para_event_handlers";

private _registration = _handlerRegistrations getOrDefault [_handlerId, []];
_registration params ["_event", "_originMachineIds"];
_event params ["_eventName", "_topic"];

private _machineIdsToStopForwarding = [];

{
    private _machineId = _x;
    // This should be guaranteed by attachHandler to always be a valid path
    private _listeners = _eventListenersByOrigin get _machineId get _eventName get _topic;
    _listeners deleteAt (_listeners find _handlerId);
    if (_listeners isEqualTo []) then {
        _machineIdsToStopForwarding pushBack _machineId;
    };
} forEach _originMachineIds;

_allHandlers deleteAt _handlerId;

if !(_machineIdsToStopForwarding isEqualTo []) then {
    [_machineIdsToStopForwarding, _event] remoteExec ["para_s_fnc_event_stopForwardingMatchingEvents", 2];
};
