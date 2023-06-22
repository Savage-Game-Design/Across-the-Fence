/*
    File: fn_netmap_makeIntoNamedNetmap copy.sqf
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

params ["_hashMap"];

private _netmapDetails = _hashMap get "_netmap";

if (isNil "_netmapDetails") exitWith {
    format ["netmap_terminate used on non-netmap hashmap: %1", keys _hashMap] call vgm_g_fnc_logWarning;
};

private _id = _netmapDetails get "id";
private _netmaps = localNamespace getVariable ["para_netmaps", createHashMap];

_netmaps deleteAt _id;
_hashMap deleteAt "_netmap";

[_id] remoteExecCall ["para_c_fnc_netmap_terminate", -clientOwner];
