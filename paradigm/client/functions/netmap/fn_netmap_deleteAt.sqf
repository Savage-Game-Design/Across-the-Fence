/*
    File: fn_netmap_deleteAt.sqf
    Author: Savage Game Design
    Date: 2023-06-22
    Last Update: 2023-06-30
    Public: No

    Description:
        Deletes a property on a netmap.

        Used when a property is deleted in the server, to synchronise that deletion to the client.

    Parameter(s):
        _netmapId - ID of the netmap affects [STRING]
        _key - Key that was deleted [ANY]

    Returns:
        Nothing

    Example(s):
        [_myNetmap get "_netmap" get "id", "someKey"] remoteExec ["para_c_fnc_netmap_deleteAt", -2];

 */

params ["_netmapId", "_key"];

private _netmaps = localNamespace getVariable ["para_netmaps", createHashMap];

if !(_netmapId in _netmaps) exitWith {
    format ["Attempted to delete key %1 on non-existent netmap %2", _key, _netmapId] call vgm_g_fnc_logError;
};

_netmaps get _netmapId deleteAt _key;
