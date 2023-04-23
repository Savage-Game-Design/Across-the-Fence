/*
    File: fn_event_registerClient.sqf
    Author: Savage Game Design
    Date: 2022-11-27
    Last Update: 2023-01-29
    Public: No

    Description:
        Registers a client with the event system when they connect.
        Does initial setup, and tells them up to globally forward events.

    Parameter(s):
        _clientMachineId - Machine id of the client to register with the system [NUMBER]

    Returns:
        Nothing

    Example(s):
        [_clientOwner] call para_s_fnc_event_registerClient
 */

params ["_clientMachineId"];

if (isRemoteExecuted && remoteExecutedOwner isNotEqualTo 0) then {
    _clientMachineId = remoteExecutedOwner;
};

["INFO", format ["Event system - registering client %1", _clientMachineId]] call para_g_fnc_log;

private _machineIdReferences = localNamespace getVariable "para_event_machineIdReferences";
private _forwardingForOriginMachineId = localNamespace getVariable "para_event_forwardingForOriginMachineId";
private _globalEventsToForward = keys (_forwardingForOriginMachineId getOrDefault [0, createHashMap]);

// This function can potentially be called multiple times - avoid overwriting any existing data.
if (_clientMachineId in _machineIdReferences) exitWith {
    ["INFO", format ["Event system attempted to double register client %1", _clientMachineId]] call para_g_fnc_log;
};

_machineIdReferences set [_clientMachineId, [_clientMachineId]];

// Only need to start forwarding global events
// Works under the assumption that other clients couldn't register client-specific events before we set the machine id reference above.
[_globalEventsToForward] remoteExec ["para_g_fnc_event_startForwardingMatchingEventsToServer", _clientMachineId];
