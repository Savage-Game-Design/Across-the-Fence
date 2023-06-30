/*
    File: fn_netmap_createNetmapFromArray.sqf
    Author: Savage Game Design
    Date: 2023-06-22
    Last Update: 2023-06-26
    Public: Yes

    Description:
        Creates a new netmap (networked hashmap), whose data is available to all clients.

        The netmaps initial data will be set the provided key-value pairs.

        Uses a random ID as the name.

    Parameter(s):
        _array - Array of key-value pairs that will be used to populate the netmap, identical to createHashMapFromArray [Array]

    Returns:
        The created netmap.

    Example(s):
        private _myNetmap = ["myNetmap"] call para_s_fnc_netmap_createNamedNetmap;
        private _myNestedNetmap = [["A", 1]] call para_s_fnc_netmap_createNetmapFromArray;
        [_myNetmap, "something", _myNestedNetmap] call para_s_fnc_netmap_set;

        // On the client
        private _myNetmap = ["myNetmap"] call para_s_fnc_netmap_get;
        private _a = _myNetmap get "something" get "A"; // Value is '1'
 */

params ["_array"];

private _lastNetmapId = localNamespace getVariable ["para_s_lastNetmapId", 0];
private _thisNetmapId = _lastNetmapId + 1;
localNamespace setVariable ["para_s_lastNetmapId", _thisNetmapId];

[_thisNetmapId, _array] call para_s_fnc_netmap_createNamedNetmapFromArray;
