/*
    File: fn_event_registerClient.sqf
    Author:
    Date: 2022-11-27
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
[_clientMachineId] remoteExec ["para_g_fnc_event_handlePlayerDisconnected", 0];
