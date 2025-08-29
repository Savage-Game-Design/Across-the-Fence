/*
    File: fn_persistence_dbGet.sqf
    Author: Savage Game Design
    Date: 2025-08-29
    Last Update: 2025-08-29
    Public: Yes

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [] call vgm_s_fnc_persistence_dbGet
 */

params ["_schema", "_uid", "_data"];

private _schemaKey = [_schema, _uid] call vgm_s_fnc_persistence_cacheKey;
[_schemaKey, _uid] call vgm_s_fnc_db_get // return
