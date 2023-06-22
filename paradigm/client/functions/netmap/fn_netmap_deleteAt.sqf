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

params ["_netmapId", "_key"];

private _netmaps = localNamespace getVariable ["para_netmaps", createHashMap];

if !(_netmapId in _netmaps) exitWith {
    format ["Attempted to delete key %1 on non-existent netmap %2", _key, _netmapId] call vgm_g_fnc_logError;
};

_netmaps get _netmapId deleteAt _key;
