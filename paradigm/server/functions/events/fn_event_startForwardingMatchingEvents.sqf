/*
    File: fn_event_startForwardingMatchingEvents.sqf
    Author:
    Date: 2022-11-24
    Last Update: 2022-12-04
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

params [
    ["_clients", nil, [[]]],
    ["_event", [], [[]], [2]],
    ["_handlerId", nil, [""]]
];

["DEBUG", format ["Starting to forward event %1 from %2 to %3", _event, _clients, remoteExecutedOwner]] call para_g_fnc_log;

_event params [
    ["_eventName", nil, [""]],
    ["_topic", nil, [""]]
];

if (isNil "_clients" || isNil "_eventName" || isNil "_topic" || isNil "_handlerId") exitWith {
    ["WARNING", format ["Bad event forwarding request from %1", remoteExecutedOwner]] call para_g_fnc_log;
};

private _originMachineIdsToListenTo = _clients apply {
    if (_x isEqualType objNull) then { owner _x } else { _x }
};

// In case they're self-targeting, we don't want to tell them forward requests.
_originMachineIdsToListenTo = _originMachineIdsToListenTo - [remoteExecutedOwner];

private _machineIdReferences = localNamespace getVariable "para_event_machineIdReferences";
private _forwardingForOriginMachineId = localNamespace getVariable "para_event_forwardingForOriginMachineId";

private _eventHash = hashValue _event;
private _listenerMachineIdReference = _machineIdReferences get remoteExecutedOwner;

// Register the client sending the request as wanting events forwarded from _clients
{
    private _listeningMachineIds = _forwardingForOriginMachineId
        getOrDefault [_x, createHashMap, true]
        getOrDefault [_eventHash, [], true];
    // Duplication shouldn't matter, remoteExec handles it more efficiently than our code can
    _listeningMachineIds pushBack _listenerMachineIdReference;
} forEach _originMachineIdsToListenTo;

// Server tells the requesting client to attach the event handlers.
// Can't be done on the client, as the server needs to resolve the machine ids as `owner` doesn't work on clients.
[_originMachineIdsToListenTo, _event, _handlerId] remoteExec ["para_g_fnc_event_attachHandler", remoteExecutedOwner];

// Server tells the other clients; to forward events on.
[_event] remoteExec ["para_g_fnc_event_startForwardingMatchingEventsToServer", _originMachineIdsToListenTo];
