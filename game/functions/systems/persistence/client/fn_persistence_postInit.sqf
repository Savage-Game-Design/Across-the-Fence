/*
    File: fn_persistence_postInit.sqf
    Author: Savage Game Design
    Date: 2025-08-28
    Last Update: 2025-08-29
    Public: No

    Description:
        Client postInit for persistence system.
 */

if (!hasInterface) exitWith {};

vgm_persistence_loaded_received = false;

["vgm_persistence_loaded", {
    vgm_persistence_loaded_received = true;
    "Persistence data load response receieved" call vgm_g_fnc_logInfo;
    {
        [] call _x;
    } forEach vgm_persistence_handlers;
}] call para_g_fnc_event_subscribeServer;

[] spawn {
    waitUntil {!isNil "vgm_g_dbBackendType"};

    vgm_persistence_loadRequested = true;

    private _schemas = missionNamespace getVariable ["vgm_persistence_schemas", []];
    ["vgm_persistence_requestLoad", [player, _schemas]] call para_g_fnc_event_triggerServer;
    format ["Requested persistence load for schemas: %1", _schemas] call vgm_g_fnc_logInfo;

    // Retry mechanism: if the server event is missed (e.g. on mission restart),
    // resend the request up to 3 times with 5-second intervals.
    private _retries = 0;
    while {_retries < 3 && !vgm_persistence_loaded_received} do {
        sleep 5;
        if (vgm_persistence_loaded_received) exitWith {};
        _retries = _retries + 1;
        format ["Persistence load not received after %1s, retrying (%2/3)...", _retries * 5, _retries] call vgm_g_fnc_logWarning;
        ["vgm_persistence_requestLoad", [player, _schemas]] call para_g_fnc_event_triggerServer;
    };
};
