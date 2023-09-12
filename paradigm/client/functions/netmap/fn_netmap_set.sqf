/*
    File: fn_netmap_set.sqf
    Author: Savage Game Design
    Date: 2023-06-22
    Last Update: 2023-06-30
    Public: No

    Description:
        Sets a key on a netmap to the given value.

        Should only be used by the server to synchronise changes.

    Parameter(s):
        _netmapId - ID of the netmap to update [STRING]
        _key - Key to update [ANY]
        _value - New value for that key [ANY]

    Returns:
        Nothing

    Example(s):
        [_myNetmap get "_netmap" get "id", "A", 1] remoteExec ["para_c_fnc_netmap_set", -2];
 */

params ["_netmapId", "_key", "_value"];

private _netmaps = localNamespace getVariable ["para_netmaps", createHashMap];

if !(_netmapId in _netmaps) exitWith {
    ["ERROR", format ["Attempted to set key %1 on non-existent netmap %2", _key, _netmapId]] call para_g_fnc_log;
};

// If value is a netmap, use our local copy, so we maintain referential integrity + updates work correctly.
if (_value isEqualType createHashMap && { "_netmap" in _value }) exitWith {
    _netmaps get _netmapId set [_key, _netmaps get (_value get "_netmap" get "id")];
};

_netmaps get _netmapId set [_key, _value];
