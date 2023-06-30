/*
    File: fn_netmap_createNetmap.sqf
    Author: Savage Game Design
    Date: 2023-06-22
    Last Update: 2023-06-26
    Public: Yes

    Description:
        Creates a new netmap (networked hashmap), whose data is available to all clients.

        Uses a random ID as the name.

    Parameter(s):
        None

    Returns:
        The created netmap.

    Example(s):
        // On the server
        private _myNetmap = ["myNetmap"] call para_s_fnc_netmap_createNamedNetmap;
        private _myNestedNetmap = [] call para_s_fnc_netmap_createNetmap;

        [_myNetmap, "something", _myNestedNetmap] call para_s_fnc_netmap_set;
        [_myNestedNetmap, "A", 1] call para_s_fnc_netmap_set;

        // On the client
        private _myNetmap = ["myNetmap"] call para_s_fnc_netmap_get;
        private _a = _myNetmap get "something" get "A"; // Value is '1'
 */

params [];

[[]] call para_s_fnc_netmap_createNetmapFromArray;
