/*
    File: fn_event_registerClient.sqf
    Author: Savage Gmae Design
    Date: 2022-11-27
    Last Update: 2023-01-29
    Public: No

    Description:
        Unregisters a client when they disconnect, cleaning up after them.
        Tells any other clients to clean up and remove any data associated with the disconnected client.

    Parameter(s):
        _clientMachineId - Machine id of the client to unregister (usually after disconnect) [NUMBER]

    Returns:
        Nothing

    Example(s):
        [_disconnectedOwner] call para_s_fnc_event_unregisterClient
 */

params ["_clientMachineId"];

private _machineIdReferences = localNamespace getVariable "para_event_machineIdReferences";
private _forwardingForOriginMachineId = localNamespace getVariable "para_event_forwardingForOriginMachineId";

// Removes all forwarding entries originating from the disconnected client
_forwardingForOriginMachineId deleteAt _clientMachineId;

// Removes all forwarding addressed to the originating client.
_machineIdReferences get _clientMachineId resize 0;
_machineIdReferences deleteAt _clientMachineId;

// Clients may still forward to the server, which will tell them to stop forwarding if no listeners left.

// Tell all clients to remove any listeners for that machine specifically.
[_clientMachineId] remoteExec ["para_g_fnc_event_handlePlayerDisconnected", -_clientMachineId];
