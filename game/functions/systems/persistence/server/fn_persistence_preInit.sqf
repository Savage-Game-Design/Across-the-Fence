/*
    File: fn_persistence_preInit.sqf
    Author: Savage Game Design
    Date: 2025-08-28
    Last Update: 2025-09-11
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

// TODO move to postInit file
[] spawn {
    ["persistence_dbCommit", { [] call vgm_s_fnc_persistence_dbCommit }, [], 120] call para_g_fnc_scheduler_add_job;

    // Should fire *after* levelling rewards are given, so progress is persisted.
    ["vgm_mission_ended", {
        [] call vgm_s_fnc_persistence_dbCommit
    }] call para_g_fnc_event_subscribeServer;

    addMissionEventHandler ["HandleDisconnect", {
        [] call vgm_s_fnc_persistence_dbCommit;
        // if this EH code returns true... player... becomes AI
        // https://community.bistudio.com/wiki/Arma_3:_Mission_Event_Handlers#HandleDisconnect
        false
    }];
};
