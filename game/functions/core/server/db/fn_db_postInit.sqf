/*
    File: fn_display_postInit.sqf
    Author: Savage Game Design
    Date: 2024-03-24
    Last Update: 2025-06-29
    Public: No

    Description:
        PostInit for database and persistence.
 */

if (!isServer) exitWith {};

if (
    isDedicated // TODO check if backend should be enabled
) then {
    [] call vgm_s_fnc_db_backend_init;
} else {
    "Using local profile for storage" call vgm_g_fnc_logInfo;
    missionNamespace setVariable ["vgm_g_dbBackendType", "profile", true];
};

["db_save_mission_namespace", { [] call vgm_s_fnc_db_persist }, [], 120] call para_g_fnc_scheduler_add_job;

// Should fire *after* levelling rewards are given, so progress is persisted.
["vgm_mission_ended", {
    [] call vgm_s_fnc_db_persist
}] call para_g_fnc_event_subscribeServer;
