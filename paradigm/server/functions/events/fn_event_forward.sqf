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

private _forwardingForOriginMachineId = localNamespace getVariable "para_event_forwardingForOriginMachineId";

private _machinesListeningToAllOrigins = _forwardingForOriginMachineId
    getOrDefault [0, createHashMap]
    getOrDefault [_eventHash, []];

private _machinesListeningToThisOrigin = _forwardingForOriginMachineId
    getOrDefault [_originMachineId, createHashMap]
    getOrDefault [_eventHash, []];

[_originMachineId, _event, _data] remoteExec ["para_g_fnc_event_callRegisteredHandlers", flatten (_machinesListeningToAllOrigins + _machinesListeningToThisOrigin)];
