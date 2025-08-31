/*
    File: fn_persistence_preInit.sqf
    Author: Savage Game Design
    Date: 2025-08-28
    Last Update: 2025-08-30
    Public: No

    Description:
        Server preInit for persistence system.
 */

if (!isServer) exitWith {};

vgm_persistence_playerRequests = createHashMap;
vgm_persistence_requestPlayer = createHashMap;

vgm_persistence_dirtySchemas = createHashMap;

["vgm_persistence_requestLoad", {
    params ["_eventArgs"];
    _eventArgs params ["_player", "_schemas"];
    [_player, _schemas] call vgm_s_fnc_persistence_load;
}] call para_g_fnc_event_subscribe;
