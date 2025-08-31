/*
    File: fn_persistence_dbSave.sqf
    Author: Savage Game Design
    Date: 2025-08-29
    Last Update: 2025-08-31
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [] call vgm_s_fnc_persistence_dbCommit
 */

if (vgm_g_dbBackendType == "profile") exitWith {
    [] call vgm_s_fnc_db_persist;
    {
        private _uid = _x;
        vgm_persistence_dirtySchemas deleteAt _uid;
        format ["Persistence save for uid %1", _uid] call vgm_g_fnc_logInfo;
    } forEach vgm_persistence_dirtySchemas;

    true
};

{
    private  _uid = _x;
    private  _schemas = _y;
    {
        private _schema = _x;
        // get cached value
        private _data = [_schema, _uid] call vgm_s_fnc_persistence_dbGet;

        format ["Persistence save for %1, uid %2", _schema, _uid] call vgm_g_fnc_logInfo;

        private _response = [format ["persistence:%1:set", _schema], [_uid, _data]] call vgm_s_fnc_extension_call;
        _response params ["_requestId", "_success"];

        if (!_success) then {
            format ["Failed to send persistence data: %1, %2", _uid, _schema] call vgm_g_fnc_logError;
            continue;
        };

        // TODO this is bit ugly, get holds the player but set stores the uid directly
        // however get will not use set data and vice versa so it's safe to do
        vgm_persistence_requestPlayer set [_requestId, _uid];

    } forEach _schemas;
    vgm_persistence_dirtySchemas deleteAt _uid;
} forEach vgm_persistence_dirtySchemas;

true
