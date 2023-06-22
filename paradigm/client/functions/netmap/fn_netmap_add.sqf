/*
    File: fn_netmap_add.sqf
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

params ["_netmap"];

private _netmaps = localNamespace getVariable ["para_netmaps", createHashMap];

[_netmap] call para_c_fnc_netmap_fixReferences;

_netmaps set [_netmap get "_netmap" get "id", _netmap];


