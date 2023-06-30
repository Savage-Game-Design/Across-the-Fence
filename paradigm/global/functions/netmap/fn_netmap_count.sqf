/*
    File: fn_netmap_count.sqf
    Author: Savage Game Design
    Date: 2023-06-23
    Last Update: 2023-06-26
    Public: Yes

    Description:
        Counts the number of items in a netmap.

        Equivalent to `count _hashmap`.

        Needed as the `_netmap` metadata key causes the count to be incorrect.

    Parameter(s):
        _netmap - Netmap to count the keys in [HashMap]

    Returns:
        Number of keys registered in the netmap [NUMBER]

    Example(s):
        private _myNetmap = ["myNetmap"] call para_g_fnc_netmap_get;
        private _totalEntries = [_myNetmap] call para_g_fnc_netmap_count;
 */

params ["_netmap"];

// Removes the _netmap entry from the count
(count _netmap - 1) max 0
