/*
    File: fn_event_onPlayerDisconnect.sqf
    Author:
    Date: 2022-11-27
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

params ["_id", "_uid", "_name", "_jip", "_owner", "_idstr"];

private _machineIdReferences = localNamespace getVariable "para_event_machineIdReferences";
private _forwardingForOriginMachineId = localNamespace getVariable "para_event_forwardingForOriginMachineId";

// Removes all forwarding entries originating from the disconnected client
_forwardingForOriginMachineId deleteAt _owner;

// Removes all forwarding addressed to the originating client.
_machineIdReferences get _owner resize [0];
_machineIdReferences deleteAt _owner;

// Clients will still forward to the server, which will tell them to stop forwarding if no listeners left.

// Tell all clients to remove any listeners for that machine specifically.
[_owner] remoteExec ["para_g_fnc_event_handlePlayerDisconnected", /* TODO: Track all players listening */];
