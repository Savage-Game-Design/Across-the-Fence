/*
    File: fn_persistence_dbGet.sqf
    Author: Savage Game Design
    Date: 2025-08-29
    Last Update: 2025-08-30
    Public: Yes

    Description:
        Get persistence data from the database.

    Parameter(s):
        _schema - Schema name [STRING]
        _uid - Player UID [STRING]

    Returns:
        Something [BOOL]

    Example(s):
        ["leveling", "76561197993041837"] call vgm_s_fnc_persistence_dbGet
 */

params [
    ["_schema", nil, [""]],
    ["_uid", nil, [""]]
];

if (!(vgm_persistence_registeredSchemas getOrDefault [_schema, false])) then {
    format ["Unknown schema for get: %1", _schema] call vgm_g_fnc_logError;
};

private _cacheKey = _schema call vgm_s_fnc_persistence_cacheKey;
[_cacheKey, _uid] call vgm_s_fnc_db_get // return
