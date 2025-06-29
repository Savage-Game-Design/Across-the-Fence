/*
    File: fn_db_clear.sqf
    Author: Cerebral
    Date: 2022-11-11
    Last Update: 2025-06-29
    Public: No

    Description:
        Clears the database of all entries.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        call vgm_s_fnc_db_clear;

*/

private _fnc = format ["vgm_s_fnc_db_%1_clear", missionNamespace getVariable "vgm_g_dbBackendType"];
[] call (missionNamespace getVariable [_fnc, {format ["Invalid DB function: %1", _fnc]}]) // return
