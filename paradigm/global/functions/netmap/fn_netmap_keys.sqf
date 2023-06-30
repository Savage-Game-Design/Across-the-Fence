/*
    File: fn_netmap_keys.sqf
    Author: Savage Game Design
    Date: 2023-06-23
    Last Update: 2023-06-30
    Public: Yes

    Description:
        Returns the keys in a netmap.

        Equivalent to `keys _hashmap`.

        Needed as the `_netmap` metadata key would otherwise be included.

    Parameter(s):
        _netmap - Netmap to return the keys of [HashMap]

    Returns:
        Array of keys that are added to the netmap [ARRAY]

    Example(s):
        private _myNetmap = [[["A", 1], ["B", 2]]] call para_s_fnc_netmap_createFromArray;
        private _keys = [_myNetmap] call para_g_fnc_netmap_keys;
        // _keys is ["A", "B"]
 */

params ["_netmap"];

keys _netmap - ["_netmap"]
