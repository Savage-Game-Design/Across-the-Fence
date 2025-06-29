/*
    File: fn_db_profile_persist.sqf
    Author: Savage Game Design
    Date: 2025-06-29
    Last Update: 2025-06-29
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

private _currentTime = diag_tickTime;
saveProfileNamespace;
// Track the time, to make it easier to identify if the profile namespace saving is causing stutters (which it did in Mike Force).
[format ["Mission database saved in %1 seconds", diag_tickTime - _currentTime]] call vgm_g_fnc_logInfo;
