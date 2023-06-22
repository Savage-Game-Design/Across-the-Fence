/*
    File: fn_netmap_create.sqf
    Author:
    Date: 2023-06-22
    Last Update: 2023-06-22
    Public: No

    Description:
        p, and makes it available on the client using the given name.

    Parameter(s):
        _name - Name that the clients will be able to access the hashmap using. Optional, will use a random ID if not provided. [String]

    Returns:
        The original hashmap passed in as an argument.

    Example(s):
        private _myNetmap = createHashMap;
        [_myNetmap, "myNetmap"] call para_s_fnc_netmap_makeIntoNamedNetmap;

        // On the client
        private _myNetmap = ["myNetmap"] call para_s_fnc_netmap_get;
 */

params ["_name", ["_array", []]];

private _netmaps = localNamespace getVariable ["para_netmaps", createHashMap];

if (_name in _netmaps) exitWith {
    format ["Duplicate netmap with ID %1", _name] call vgm_g_fnc_logError;
};

private _hashMap = createHashMapFromArray _array;

_hashMap set ["_netmap", createHashMapFromArray [
    ["id", _name]
]];

_netmaps set [_name, _hashMap];

localNamespace setVariable ["para_netmaps", _netmaps];

[_hashMap] remoteExecCall ["para_c_fnc_netmap_add", -clientOwner];

_hashMap

