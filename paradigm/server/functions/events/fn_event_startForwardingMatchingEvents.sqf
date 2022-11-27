/*
    File: fn_event_startForwardingMatchingEvents.sqf
    Author:
    Date: 2022-11-24
    Last Update: 2022-11-27
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

_event params [
    ["_eventName", nil, [""]],
    ["_topic", nil, [""]]
];

if (isNil "_clients" || isNil "_eventName" || isNil "_topic" || isNil "_handlerId") exitWith {
    ["WARNING", format ["Bad event forwarding request from %1", remoteExecutedOwner]] call para_g_fnc_log;
};

private _clientMachineIds = _clients apply {
    if (_x isEqualType objNull) then { owner _x } else { _x }
};

// In case they're self-targeting, we don't want to tell them forward requests.
_clientMachineIds = _clientMachineIds - [remoteExecutedOwner];

private _machineIdReferences = localNamespace getVariable "para_event_machineIdReferences";
private _machineIdReservedIndexes = localNamespace getVariable "para_event_machineIdToReservedClientArrayIndex";
private _specificMachineListeners = localNamespace getVariable "para_event_specificMachineListeners";

private _eventHash = hashValue _event;
private _specificMachineIds = _clientMachineIds select { _x >= 1 };
private _listenerMachineIdReference = _machineIdReferences get remoteExecutedOwner;

// Handle specific machine ids (2, 3, 46, etc)
{
    private _listeningMachineIds = _specificMachineListeners
        getOrDefault [_x, createHashMap, true]
        getOrDefault [_eventHash, [], true];
    // Duplication shouldn't matter, remoteExec handles it more efficiently than our code can
    _listeningMachineIds pushBack _listenerMachineIdReference;
} forEach _specificMachineIds;

// Server tells the requesting client to attach the event handlers.
// Can't be done on the client, as the server needs to resolve the machine ids as `owner` doesn't work on clients.
[_clientMachineIds, _event, _handlerId] remoteExec ["para_g_fnc_event_attachHandler", remoteExecutedOwner];

// Server tells the other clients; to forward events on.
[_event] remoteExec ["para_g_fnc_event_startForwardingMatchingEventsToServer", _clientMachineIds];





