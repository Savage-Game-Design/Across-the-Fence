/*
    File: fn_event_onPlayerConnected.sqf
    Author:
    Date: 2022-11-27
    Last Update: 2022-12-24
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
