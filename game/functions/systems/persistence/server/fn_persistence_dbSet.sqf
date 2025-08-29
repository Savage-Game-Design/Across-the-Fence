/*
    File: fn_persistence_dbSet.sqf
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
        [parameter] call vgm_s_fnc_persistence_dbSet
 */

params ["_schema", "_uid", "_data"];

private _schemaKey = [_schema, _uid] call vgm_s_fnc_persistence_cacheKey;
vgm_persistence_dirtyKeys set [_schemaKey, nil];

[_schemaKey, _uid, _data] call vgm_s_fnc_db_typed_save // return
