/*
    File: fn_event_onPlayerConnected.sqf
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

params ["_id", "_uid", "_name", "_jip", "_owner"];

// This can potentially be done via getOrDefault if it's simpler to remove this function.
private _machineIdReferences = localNamespace getVariable "para_event_machineIdReferences";

_machineIdReferences set [_owner, [_owner]];
