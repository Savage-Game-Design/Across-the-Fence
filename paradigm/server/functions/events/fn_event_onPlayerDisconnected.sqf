/*
    File: fn_event_onPlayerDisconnect.sqf
    Author:
    Date: 2022-11-27
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

params ["_id", "_uid", "_name", "_jip", "_owner", "_idstr"];

private _machineIdReferences = localNamespace getVariable "para_event_machineIdReferences";
private _machineIdReservedIndexes = localNamespace getVariable "para_event_machineIdToReservedClientArrayIndex";
private _specificMachineListeners = localNamespace getVariable "para_event_specificMachineListeners";

_specificMachineListeners deleteAt _owner;

// Removes all forwarding requests from this client, as it's a reference.
_machineIdReferences get _owner resize [0];

// Frees up the index for use by another client.
_machineIdReservedIndexes deleteAt _owner;

// Disconnect:
// Null out machineId reference
// Remove index reservation
// Move the -X listeners to 0?
// Delete the machine specific handlers hashmap entry for the machine id
// Tell all clients to stop listening to events from that client
// Tell all clients to stop forwarding any events needed specifically for that client?
