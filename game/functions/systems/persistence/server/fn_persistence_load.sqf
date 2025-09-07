/*
    File: fn_persistence_load.sqf
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
        [] call vgm_s_fnc_persistence_load
 */

params [
    ["_player", objNull, [objNull]],
    ["_schemas", [], [[]]]
];
private _playerUID = getPlayerUID _player;

if (vgm_g_dbBackendType == "profile") exitWith {
    format ["Skipping persistence load for player %1, profile storage in use", _playerUID] call vgm_g_fnc_logDebug;
    _player spawn {
        if (is3DENPreview) then {uiSleep 3}; // debug delay to simulate load time
        ["vgm_persistence_loaded", [], _this] call para_g_fnc_event_triggerTargets;
    };
};

format ["Loading persistence data for player: %1, %2", _playerUID, _schemas] call vgm_g_fnc_logInfo;

{
    _x params ["_schema"];

    _schema call vgm_s_fnc_persistence_registerSchema;

    private _response = [format ["persistence:%1:get", _schema], [getPlayerUID _player]] call vgm_s_fnc_extension_call;
    _response params ["_requestId", "_success"];

    if (!_success) then {
        format ["Failed to request persistence data: %1, %2", _playerUID, _schema] call vgm_g_fnc_logError;
        continue;
    };

    private _playerSchemaRequests = vgm_persistence_playerRequests getOrDefault [_playerUID, createHashMap, true];
    _playerSchemaRequests set [_requestId, _schema];

    vgm_persistence_requestPlayer set [_requestId, _player];

} forEach _schemas;
