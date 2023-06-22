/*
    File: fn_netmap_get.sqf
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

params ["_netmapId", ["_defaultValue", nil]];

private _netmaps = localNamespace getVariable ["para_netmaps", createHashMap];

_netmaps getOrDefault [_netmapId, _defaultValue]
