/*
    File: fn_netmap_set.sqf
    Author: Savage Game Design
    Date: 2023-06-22
    Last Update: 2023-06-26
    Public: No

    Description:
        Sets a key in a hashmap to a particular value, and then sends that over the network to all clients.

    Parameter(s):
        _netmap - Netmap whose key should be set to value [HashMap]
        _key - Key to set [ANY]
        _value - Value to set [ANY]

    Returns:
        Nothing

    Example(s):
        private _myNetmap = [] call para_s_fnc_netmap_createNetmap;
        [_myNetmap, "A", 1] call para_s_fnc_netmap_set;

        _myNetmap get "A"; // Returns 1
 */

params ["_netmap", "_key", "_value"];

private _netmapDetails = _netmap get "_netmap";

_netmap set [_key, _value];

if (isNil "_netmapDetails") exitWith {
    format ["netmap_set used on non-netmap hashmap: %1", keys _netmap] call vgm_g_fnc_logWarning;
};

[_netmapDetails get "id", _key, _value] remoteExecCall ["para_c_fnc_netmap_set", -clientOwner];
