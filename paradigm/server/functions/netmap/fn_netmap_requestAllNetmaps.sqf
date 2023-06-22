/*
    File: fn_netmap_requestAllNetmaps.sqf
    Author:
    Date: 2023-06-22
    Last Update: 2023-06-22
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

params ["_sender"];

if (_sender isNotEqualTo remoteExecutedOwner && remoteExecutedOwner != 0) exitWith {
    format ["machine %1 claimed to be %2 when requesting netmaps", remoteExecutedOwner, _sender] call vgm_g_fnc_logError;
};

private _netmaps = localNamespace getVariable ["para_netmaps", createHashMap];

["netmaps received", _netmaps, [_sender]] call para_g_fnc_event_triggerTargets;

