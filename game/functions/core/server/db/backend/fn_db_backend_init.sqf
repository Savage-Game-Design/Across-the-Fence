/*
    File: fn_db_backend_init.sqf
    Author: Savage Game Design
    Date: 2025-08-27
    Last Update: 2025-08-27
    Public: No

    Description:
        Initialize persistence backend.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] call vgm_s_fnc_db_backend_init
 */

"Using Across the Fence Backend API" call vgm_g_fnc_logInfo;

vgm_db_backend_connectScript = [] spawn {
    private _connected = false;
    while {!_connected} do {
        _connected = (["persistence:connect", []] call vgm_s_fnc_extension_call) select 1;
        if (!_connected) then {
            ["Failed to connect to backend, delaying by 10s"] call vgm_g_fnc_logError;
            uiSleep 10
        };
    };
    ["Connected to backend"] call vgm_g_fnc_logInfo;
    missionNamespace setVariable ["vgm_g_dbBackendType", "backend", true];
};
