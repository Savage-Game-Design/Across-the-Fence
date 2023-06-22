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

params ["_netmapId", "_key", "_value"];

private _netmaps = localNamespace getVariable ["para_netmaps", createHashMap];

if !(_netmapId in _netmaps) exitWith {
    format ["Attempted to set key %1 on non-existent netmap %2", _key, _netmapId] call vgm_g_fnc_logError;
};

// If value is a netmap, use our local copy, so we maintain referential integrity + updates work correctly.
if (_value isEqualType createHashMap && { "_netmap" in _value }) exitWith {
    _netmaps get _netmapId set [_key, _netmaps get (_value get "_netmap" get "id")];
};

_netmaps get _netmapId set [_key, _value];
