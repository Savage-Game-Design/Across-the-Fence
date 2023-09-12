/*
    File: fn_netmap_get.sqf
    Author: Savage Game Design
    Date: 2023-06-23
    Last Update: 2023-06-30
    Public: Yes

    Description:
        Fetches the netmap with the provided name or ID.

    Parameter(s):
        _netmapId - ID of the netmap, either the name it was created with, or generated id [STRING]

    Returns:
        The netmap if it exists, nil otherwise

    Example(s):
        private _myNetmap = ["myNetmap"] call para_g_fnc_netmap_get;
 */

params ["_netmapId"];

private _netmaps = localNamespace getVariable ["para_netmaps", createHashMap];

_netmaps get _netmapId
