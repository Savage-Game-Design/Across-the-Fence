/*
    File: fn_netmap_terminate.sqf
    Author: Savage Game Design
    Date: 2023-06-22
    Last Update: 2023-09-28
    Public: Yes

    Description:
        Terminates networking on a netmap, turning it into a normal hashmap.

        Removes the `_netmap` key, and clears the netmap from the serverside and clientside netmap systems.

        Does NOT delete the hashmap - anything with a reference to the hashmap will still hold that reference.

    Parameter(s):
        _netmap - Netmap to stop the networking on [HashMap]

    Returns:
        Nothing

    Example(s):
        private _myNetmap = [] call para_s_fnc_netmap_createNetmap;

        [_myNetmap] call para_s_fnc_netmap_terminate;
 */

params ["_netmap"];

private _netmapDetails = _netmap get "_netmap";

if (isNil "_netmapDetails") exitWith {
    ["WARNING", format ["netmap_terminate used on non-netmap hashmap: %1", keys _netmap]] call para_g_fnc_log;
};

private _ownedNetmapIds = _netmapDetails get "ownedNetmaps";
private _netmaps = localNamespace getVariable ["para_netmaps", createHashMap];
private _id = _netmapDetails get "id";

[_netmap, nil] call para_s_fnc_netmap_setOwningNetmap;

{
    private _ownedNetmap = _netmaps get _x;
    [_ownedNetmap] call para_s_fnc_netmap_terminate;
} forEach _ownedNetmapIds;

_netmap deleteAt "_netmap";
_netmaps deleteAt _id;
[_id] remoteExecCall ["para_c_fnc_netmap_terminate", -clientOwner];
