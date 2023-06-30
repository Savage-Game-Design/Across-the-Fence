/*
    File: fn_netmap_deleteAt.sqf
    Author: Savage Game Design
    Date: 2023-06-22
    Last Update: 2023-06-30
    Public: Yes

    Description:
        Deletes the given key from the netmap, and immediately synchronises it to the clients.

    Parameter(s):
        _netmap - Netmap to delete entry from [HashMap]
        _key - Key to delete [ANY]

    Returns:
        Nothing

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

params ["_hashMap", "_key"];

private _netmapDetails = _hashMap get "_netmap";

_hashMap deleteAt _key;

if (isNil "_netmapDetails") exitWith {
    ["WARNING", format ["netmap_deleteAt used on non-netmap hashmap: %1", keys _hashMap]] call para_g_fnc_log;
};

[_netmapDetails get "id", _key] remoteExecCall ["para_c_fnc_netmap_deleteAt", -clientOwner];

