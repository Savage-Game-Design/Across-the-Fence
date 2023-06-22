/*
    File: fn_netmap_deleteAt.sqf
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

params ["_hashMap", "_key"];

private _netmapDetails = _hashMap get "_netmap";

_hashMap deleteAt _key;

if (isNil "_netmapDetails") exitWith {
    format ["netmap_deleteAt used on non-netmap hashmap: %1", keys _hashMap] call vgm_g_fnc_logWarning;
};

[_netmapDetails get "id", _key] remoteExecCall ["para_c_fnc_netmap_deleteAt", -clientOwner];

