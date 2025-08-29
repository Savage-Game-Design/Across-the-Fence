/*
    File: fn_persistence_registerSchema.sqf
    Author: Savage Game Design
    Date: 2025-08-28
    Last Update: 2025-08-29
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Schema was registered [BOOL]

    Example(s):
        ["leveling"] call vgm_c_fnc_persistence_registerSchema
 */

params [["_schema", "", [""]]];

private _loaded = missionNamespace getVariable ["vgm_persistence_loadRequested", false];
if (_loaded) exitWith {
    "Schema load already requested. Schemas must be registered in preInit!" call vgm_g_fnc_logError;
    false
};

format ["Registering persistence schema: %1", _schema] call vgm_g_fnc_logDebug;

if (isNil "vgm_persistence_schemas") then {
    vgm_persistence_schemas = [];
};

vgm_persistence_schemas pushBackUnique _schema;

true
