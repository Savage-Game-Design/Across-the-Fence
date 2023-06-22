/*
    File: fn_netmap_add.sqf
    Author:
    Date: 2023-06-22
    Last Update: 2023-06-22
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

params ["_netmapId"];

private _netmaps = localNamespace getVariable ["para_netmaps", createHashMap];

if !(_netmapId in _netmaps) exitWith {
    format ["Attempted to delete non-existent netmap %1", _netmapId] call vgm_g_fnc_logError;
};

// Remove the metadata, so the client knows this is no longer a netmap
_netmaps get _netmapId deleteAt "_netmap";
// Clear it out of the netmap system.
_netmaps deleteAt _netmapId;
