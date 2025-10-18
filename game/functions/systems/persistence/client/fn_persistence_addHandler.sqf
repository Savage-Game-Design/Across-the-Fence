/*
    File: fn_persistence_addHandler.sqf
    Author: Savage Game Design
    Date: 2025-08-28
    Last Update: 2025-09-20
    Public: Yes

    Description:
        Registers function to execute after persistence data was loaded on server.

    Parameter(s):
        _fnc_handler - Function to call after persistence data was loaded [CODE]

    Returns:
        Nothing

    Example(s):
        [{diag_log "persistence loaded!"}] call vgm_c_fnc_persistence_addHandler
 */

params ["_fnc_handler"];

if (isNil "vgm_persistence_handlers") then {
    vgm_persistence_handlers = [];
};

if (missionNamespace getVariable ["vgm_persistence_handlersLoaded", false]) exitWith {
    ["Handler registered after persistence data was loaded, calling immediately: %1", _fnc_handler] call vgm_g_fnc_logInfo;
    [] call _fnc_handler;
};

vgm_persistence_handlers pushBack _fnc_handler;

nil
