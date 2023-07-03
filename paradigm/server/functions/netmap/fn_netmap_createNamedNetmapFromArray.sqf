/*
    File: fn_netmap_createNamedNetmapFromArray.sqf
    Author: Savage Game Design
    Date: 2023-06-22
    Last Update: 2023-06-26
    Public: Yes

    Description:
        Creates a new netmap (networked hashmap), whose data is available to all clients using the name provided.

        The netmaps initial data will be set the provided key-value pairs.

    Parameter(s):
        _name - Name that the clients will be able to access the netmap using. [String]
        _array - Array of key-value pairs that will be used to populate the netmap, identical to createHashMapFromArray [Array]

    Returns:
        The created netmap.

    Example(s):
        private _myNetmap = ["myNetmap", [["A", 1]]] call para_s_fnc_netmap_createNamedNetmapFromArray;

        // On the client
        private _myNetmap = ["myNetmap"] call para_s_fnc_netmap_get;
        private _a = _myNetmap get "A"; // Value is '1'
 */

params ["_name", ["_array", []]];

private _netmaps = localNamespace getVariable ["para_netmaps", createHashMap];

if (_name in _netmaps) exitWith {
    ["ERROR", format ["Duplicate netmap with ID %1", _name]] call para_g_fnc_log;
};

private _hashMap = createHashMapFromArray _array;

_hashMap set ["_netmap", createHashMapFromArray [
    ["id", _name]
]];

_netmaps set [_name, _hashMap];

localNamespace setVariable ["para_netmaps", _netmaps];

[_hashMap] remoteExecCall ["para_c_fnc_netmap_add", -clientOwner];

_hashMap

