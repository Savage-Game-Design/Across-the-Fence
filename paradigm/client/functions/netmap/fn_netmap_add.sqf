/*
    File: fn_netmap_add.sqf
    Author: Savage Game Design
    Date: 2023-06-22
    Last Update: 2023-06-30
    Public: No

    Description:
        Stores a new netmap on the client. Called by the server when a new netmap is created.

        Maintains referential consistency - if two netmaps refer to a third netmap on the server,
        then they'll refer to the same netmap on the client.

    Parameter(s):
        _netmap - Netmap to store on the client. Must have a `_netmap` property [HashMap]

    Returns:
        Nothing

    Example(s):
        [_myNetmap] remoteExec ["para_c_fnc_netmap_add", -2];
 */

params ["_netmap"];

private _netmaps = localNamespace getVariable ["para_netmaps", createHashMap];

[_netmap] call para_c_fnc_netmap_fixReferences;

_netmaps set [_netmap get "_netmap" get "id", _netmap];


