/*
    File: fn_netmap_makeIntoNamedNetmap.sqf
    Author:
    Date: 2023-06-22
    Last Update: 2023-06-22
    Public: No

    Description:
        Initialises networking on a hashmap, and makes it available on the client using the given name.

    Parameter(s):
        _hashMap - hashmap to network [HashMap]
        _name - Name that the clients will be able to access the hashmap using. Optional, will use a random ID if not provided. [String]

    Returns:
        The original hashmap passed in as an argument.

    Example(s):
        private _myNetmap = createHashMap;
        [_myNetmap, "myNetmap"] call para_s_fnc_netmap_makeIntoNamedNetmap;

        // On the client
        private _myNetmap = ["myNetmap"] call para_s_fnc_netmap_get;
 */

params ["_name"];

[_name, []] call para_s_fnc_netmap_createNamedNetmapFromArray

