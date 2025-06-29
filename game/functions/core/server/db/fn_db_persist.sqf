/*
    File: fn_db_persist.sqf
    Author: Savage Game Design
    Date: 2024-12-05
    Last Update: 2025-06-29
    Public: No

    Description:
        Persists the database to disk (i.e calls saveProfileNamespace)

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_s_fnc_db_persist;
 */

private _fnc = format ["vgm_s_fnc_db_%1_persist", missionNamespace getVariable "vgm_g_dbBackendType"];
[] call (missionNamespace getVariable [_fnc, {format ["Invalid DB function: %1", _fnc]}]) // return
