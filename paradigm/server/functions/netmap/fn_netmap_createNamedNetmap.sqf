/*
    File: fn_netmap_createNamedNetmap.sqf
    Author: Savage Game Design
    Date: 2023-06-22
    Last Update: 2023-06-26
    Public: Yes

    Description:
        Creates a new netmap (networked hashmap), whose data is available to all clients using the name provided.

    Parameter(s):
        _name - Name that the clients will be able to access the hashmap using. [String]

    Returns:
        The created hashmap.

    Example(s):
        private _myNetmap = ["myNetmap"] call para_s_fnc_netmap_createNamedNetmap;

        // On the client
        private _myNetmap = ["myNetmap"] call para_s_fnc_netmap_get;
 */

params ["_name"];

[_name, []] call para_s_fnc_netmap_createNamedNetmapFromArray

