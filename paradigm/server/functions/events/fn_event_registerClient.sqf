/*
    File: fn_event_onPlayerConnected.sqf
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

if (remoteExecutedOwner) then {
    _clientMachineId = remoteExecutedOwner;
};

private _machineIdReferences = localNamespace getVariable "para_event_machineIdReferences";

// This function can potentially be called multiple times - avoid overwriting any existing data.
if (_clientMachineId in _machineIdReferences) exitWith {
    ["INFO", format ["Event system attempted to double register client %1", _clientMachineId]] call para_g_fnc_log;
};

_machineIdReferences set [_clientMachineId, [_clientMachineId]];
