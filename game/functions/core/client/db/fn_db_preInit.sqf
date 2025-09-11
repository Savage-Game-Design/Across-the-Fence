/*
    File: fn_db_postInit.sqf
    Author: Savage Game Design
    Date: 2025-06-29
    Last Update: 2025-09-11
    Public: No

    Description:
        Client preInit function for database system.
 */

if (!hasInterface) exitWith {};

["db", {
    !isNil "vgm_g_dbBackendType"
}] call vgm_c_fnc_loading_addHandler;
