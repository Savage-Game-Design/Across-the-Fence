/*
    File: fn_netmap_set.sqf
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

params ["_hashMap", "_key", "_value"];

private _netmapDetails = _hashMap get "_netmap";

_hashMap set [_key, _value];

if (isNil "_netmapDetails") exitWith {
    format ["netmap_set used on non-netmap hashmap: %1", keys _hashMap] call vgm_g_fnc_logWarning;
};

[_netmapDetails get "id", _key, _value] remoteExecCall ["para_c_fnc_netmap_set", -clientOwner];
