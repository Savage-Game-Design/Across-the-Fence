/*
    File: fn_netmap_values.sqf
    Author: Savage Game Design
    Date: 2023-06-23
    Last Update: 2023-06-30
    Public: Yes

    Description:
        Returns the values in a netmap.

        Equivalent to `values _hashmap`.

        Needed as otherwise the value for the `_netmap` metadata would be included.

    Parameter(s):
        _netmap - Netmap to return the values of [HashMap]

    Returns:
        Array of values that are added to the netmap [ARRAY]

    Example(s):
        private _myNetmap = [[["A", 1], ["B", 2]]] call para_s_fnc_netmap_createFromArray;
        private _values = [_myNetmap] call para_g_fnc_netmap_values;
        // _values is [1, 2]
 */

params ["_netmap"];

values _netmap - [_netmap get "_netmap"]
