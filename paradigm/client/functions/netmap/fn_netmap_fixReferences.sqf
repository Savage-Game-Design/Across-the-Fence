/*
    File: fn_netmap_fixReferences.sqf
    Author: Savage Game Design
    Date: 2023-06-22
    Last Update: 2023-06-30
    Public: No

    Description:
        Makes a netmap referentially consistent on the client.

        If on the server, we have three netmaps: A, B and C.
            A has a key "a" that references C.

        Then we set the key "b" on B to the value C.

        When this set arrives on the client, A "a" and B "b" refer to different objects,
        due to Arma deserializing them on the client.

        This function scans the values of a netmap, and if it finds any nested netmaps, it sets the
        value to the netmap object from the global netmap store.

        This means than on the client, A "a" and B "b" refer to the same hashmap.

        That way, if "C" is modified, the changes are reflected in both A "a" and B "b"

    Parameter(s):
        _netmap - Netmap to check and fix [HashMap]

    Returns:
        Nothing

    Example(s):
        [_myNewNetmap] call para_c_fnc_netmap_fixReferences;
 */

params ["_netmap"];

private _netmaps = localNamespace getVariable ["para_netmaps", createHashMap];

{
    if (_y isEqualType createHashMap && { "_netmap" in _y }) then {
        private _id = _y get "_netmap" get "id";
        _netmap set [_x, _netmaps get _id];
    };
} forEach _netmap;
