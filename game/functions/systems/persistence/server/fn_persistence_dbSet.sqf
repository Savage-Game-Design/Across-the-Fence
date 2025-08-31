/*
    File: fn_persistence_dbSet.sqf
    Author: Savage Game Design
    Date: 2025-08-29
    Last Update: 2025-08-30
    Public: Yes

    Description:
        No description added yet.

    Parameter(s):
        _schema - Schema name [STRING]
        _uid - Player UID [STRING]
        _data - Data to save [HASHMAP]

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_s_fnc_persistence_dbSet
 */

params [
    ["_schema", nil, [""]],
    ["_uid", nil, [""]],
    ["_data", nil, [createHashMap]]
];

if (!(vgm_persistence_registeredSchemas getOrDefault [_schema, false])) then {
    format ["Unknown schema for set: %1", _schema] call vgm_g_fnc_logError;
};

vgm_persistence_dirtySchemas getOrDefault [_uid, createHashMap, true] set [_schema, true];

private _cacheKey = _schema call vgm_s_fnc_persistence_cacheKey;
[_cacheKey, _uid, _data] call vgm_s_fnc_db_typed_save // return
