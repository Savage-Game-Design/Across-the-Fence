/*
    File: fn_netmap_getOrDefault.sqf
    Author: Savage Game Design
    Date: 2023-06-23
    Last Update: 2023-06-30
    Public: Yes

    Description:
        Fetches the netmap with the provided name or ID.

        Returns the provided default if it doesn't exist.

    Parameter(s):
        _netmapId - ID of the netmap, either the name it was created with, or generated id [STRING]
        _default - Default value to return if netmap doesn't exist [ANY]

    Returns:
        The netmap if it exists, the default value given otherwise.

    Example(s):
        private _myNetmap = ["myNetmap", createHashMap] call para_g_fnc_netmap_getOrDefault;
 */

private _netmaps = localNamespace getVariable ["para_netmaps", createHashMap];

_netmaps getOrDefault _this
