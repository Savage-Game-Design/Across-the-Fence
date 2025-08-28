/*
    File: fn_persistence_postInit.sqf
    Author: Savage Game Design
    Date: 2025-08-28
    Last Update: 2025-08-28
    Public: No

    Description:
        Client postInit for persistence system.
 */

if (!hasInterface) exitWith {};

["vgm_persistence_loaded", {
    "Persistence data load response receieved" call vgm_g_fnc_logInfo;
    {
        [] call _x;
    } forEach vgm_persistence_handlers;
}] call para_g_fnc_event_subscribeServer;

vgm_persistence_loadRequested = true;

private _schemas = missionNamespace getVariable ["vgm_persistence_schemas", []];
["vgm_persistence_requestLoad", [player, _schemas]] call para_g_fnc_event_triggerServer;

format ["Requested persistence load for schemas: %1", _schemas] call vgm_g_fnc_logInfo;
