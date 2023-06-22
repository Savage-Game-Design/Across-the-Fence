/*
    File: fn_netmap_fixReferences.sqf
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

params ["_netmap"];

private _netmaps = localNamespace getVariable ["para_netmaps", createHashMap];

{
    if (_y isEqualType createHashMap && { "_netmap" in _y }) then {
        private _id = _y get "_netmap" get "id";
        _netmap set [_x, _netmaps get _id];
    };
} forEach _netmap;
