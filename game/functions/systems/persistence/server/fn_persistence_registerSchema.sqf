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
        Something [BOOL]

    Example(s):
        ["leveling"] call vgm_s_fnc_persistence_registerSchema
 */

params ["_schema"];

if (isNil "vgm_persistence_registeredSchemas") then {
    vgm_persistence_registeredSchemas = createHashMap;
};

if (vgm_persistence_registeredSchemas getOrDefault [_schema, false]) exitWith {};
vgm_persistence_registeredSchemas set [_schema, true];

format ["Registering persistence schema handler: %1", _schema] call vgm_g_fnc_logInfo;

// handle schema load
[format ["%1:get", _schema], {
    params ["_resultStr", "_data", "_args"];
    format ["DB callback: %1, %2", _resultStr, _data] call vgm_g_fnc_logDebug;

    _data = parseSimpleArray _data;
    _data params ["_requestId", ["_data", createHashMap]];
    _args params ["_schema"];

    private _player = vgm_persistence_requestPlayer deleteAt _requestId;
    private _playerUID = getPlayerUID _player;

    if (_resultStr == "empty") then {
        format ["Empty data for %2 request: %1", _requestId, _schema] call vgm_g_fnc_logWarning;
        _data = createHashMap;
    };

    if (_resultStr == "error") exitWith {
        // TODO this might keep the player hanging on a loading screen
        // will get kicked by timeout so not a big issue.
        format ["Extension callback error: %1, %2", _requestId, _data] call vgm_g_fnc_logError;
    };

    if (_data isEqualType []) then {
        _data = createHashMapFromArray _data;
    };

    format ["Loaded persistence data for player: %1, %2", _playerUID, _schema] call vgm_g_fnc_logInfo;

    private _playerSchemaRequests = vgm_persistence_playerRequests get _playerUID;
    private _schema = _playerSchemaRequests deleteAt _requestId;

    // cache the data for fast immediate access in other systems
    [_schema, _playerUID, _data] call vgm_s_fnc_persistence_dbSet;

    if (_playerSchemaRequests isEqualTo createHashMap) then {
        format ["All persistence data loaded for player: %1", _playerUID] call vgm_g_fnc_logInfo;
        vgm_persistence_playerRequests deleteAt _playerUID;

        ["vgm_persistence_loaded", [], _player] call para_g_fnc_event_triggerTargets;
    };

}, [_schema]] call vgm_s_fnc_extension_setHandler;

// TODO handle saving to backend
// TODO handle player disconnects, clean data
