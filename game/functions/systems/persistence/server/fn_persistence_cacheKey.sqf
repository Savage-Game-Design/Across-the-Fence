/*
    File: fn_persistence_dbKey.sqf
    Author: Savage Game Design
    Date: 2025-08-29
    Last Update: 2025-08-30
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

params ["_schema"];

if (vgm_g_dbBackendType == "profile") exitWith {
    format ["local_%1", _schema] // return
};

format ["remote_%1", _schema] // return
