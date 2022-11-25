/*
    File: fn_event_forward.sqf
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

params ["_event", "_data"];

private _originMachineId = remoteExecutedOwner;
private _eventHash = hashValue _event;

private _machineIdReservedIndexes = localNamespace getVariable "para_event_machineIdToReservedClientArrayIndex";
private _multiMachineListeners = localNamespace getVariable "para_event_multiMachineListeners";
private _specificMachineListeners = localNamespace getVariable "para_event_specificMachineListeners";

// Shallow copy array so we can modify it.
private _multiMachineClientArray = (_multiMachineListeners getOrDefault [_eventHash, para_event_client_array_template]) + [];
// Remove any listeners for -_originMachineId.
// e.g If remote exec is from client 46, remove clients that want events from -46
_multiMachineClientArray set [_originMachineId, []];
private _multiMachineForwards = flatten _multiMachineClientArray;

private _specificMachineForwards = _specificMachineListeners
    getOrDefault [_originMachineId, createHashMap]
    getOrDefault [_eventHash, []];

[_originMachineId, _event, _data] remoteExec ["para_g_fnc_event_callRegisteredHandlers", _multiMachineForwards + _specificMachineForwards];
