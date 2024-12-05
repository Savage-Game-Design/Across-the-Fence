/*
    File: fn_db_persist.sqf
    Author: Savage Game Design
    Date: 2024-12-05
    Last Update: 2024-12-05
    Public: No

    Description:
        Persists the database to disk (i.e calls saveMissionProfileNamespace)

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_s_fnc_db_flush;
 */

private _currentTime = diag_tickTime;
saveMissionProfileNamespace;
// Track the time, to make it easier to identify if the profile namespace saving is causing stutters (which it did in Mike Force).
[format ["Mission database saved in %1 seconds", diag_tickTime - _currentTime]] call vgm_g_fnc_logInfo;
