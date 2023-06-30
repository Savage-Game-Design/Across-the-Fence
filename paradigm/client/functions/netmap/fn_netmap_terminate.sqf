/*
    File: fn_netmap_terminate.sqf
    Author: Savage Game Design
    Date: 2023-06-22
    Last Update: 2023-06-30
    Public: No

    Description:
        Stops the networking on a netmap, turning it into a normal hashmap.

        Removes the netmap from the netmap tracker, and clears the `_netmap` metadata.

        Does NOT delete the hashmap.

        Should only be used from the server.

    Parameter(s):
        _netmapId - ID of the netmap to remove from the system [STRING]

    Returns:
        Nothing

    Example(s):
        // Usage on the server
        [_myNetmap] call para_s_fnc_netmap_terminate;
        // Or to call this directly (which shouldn't be done):
        [_myNetmap get "_netmap" get "id"] remoteExec ["para_c_fnc_netmap_terminate", -2];
 */

params ["_netmapId"];

private _netmaps = localNamespace getVariable ["para_netmaps", createHashMap];

if !(_netmapId in _netmaps) exitWith {
    ["ERROR", format ["Attempted to delete non-existent netmap %1", _netmapId]] call para_g_fnc_log;
};

// Remove the metadata, so the client knows this is no longer a netmap
_netmaps get _netmapId deleteAt "_netmap";
// Clear it out of the netmap system.
_netmaps deleteAt _netmapId;
