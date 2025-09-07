/*
    File: fn_display_postInit.sqf
    Author: Savage Game Design
    Date: 2024-03-24
    Last Update: 2025-09-07
    Public: No

    Description:
        PostInit for database and persistence.
 */

if (!isServer) exitWith {};

call {
    if (
        isDedicated
        && (
            missionNamespace getVariable ["vgm_s_db_useBackend", false]
            || {profileNamespace getVariable ["vgm_forceBackend", false]}
        )
    ) then {
        [] call vgm_s_fnc_db_backend_init;
    } else {
        "Using local profile for storage" call vgm_g_fnc_logInfo;
        missionNamespace setVariable ["vgm_g_dbBackendType", "profile", true];
    };
};
