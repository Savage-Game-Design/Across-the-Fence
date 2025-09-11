
/*
    File: fn_db_preInit.sqf
    Author: Savage Game Design
    Date: 2025-09-11
    Last Update: 2025-09-11
    Public: No

    Description:
        PreInit for database and persistence.
 */


if (!isServer) exitWith {};

vgm_s_db_useBackend = [false, true] select (["db_useBackend", 0] call BIS_fnc_getParamValue);
