/*
    File: fn_loading_postInit.sqf
    Author: Savage Game Design
    Date: 2023-09-08
    Last Update: 2024-11-22
    Public: No

    Description:
        Client postInit function for loading system.
 */

#define TIMEOUT 30

["vgm_loading", "", "VGM_DisplayLoading"] call BIS_fnc_startLoadingScreen;
localize "STR_LOADING" call vgm_c_fnc_loading_setText;
0 call BIS_fnc_progressLoadingScreen;

private _handlers = missionNamespace getVariable ["vgm_loading_handlers", []];
[_handlers] spawn {
    params ["_handlers"];

    private _timeout = diag_tickTime + TIMEOUT;
    private _total = count _handlers;
    while {count _handlers > 0} do {
        {
            // spawn handlers to prevent them from breaking current script
            private _script = [_x, _handlers, _forEachIndex] spawn {
                params ["_x", "_handlers", "_forEachIndex"];
                if (call (_x get "handler")) then {
                    _handlers deleteAt _forEachIndex;
                };
            };
            waitUntil {scriptDone _script};
        } forEachReversed _handlers;

        // Loading... ticker text
        format [
            "%1%2 %3",
            localize "STR_LOADING",
            [] call vgm_c_fnc_loading_tickerDots,
            (_handlers apply {_x get "name"}) joinString endl
        ] call vgm_c_fnc_loading_setText;

        (1 - (count _handlers / _total)) call BIS_fnc_progressLoadingScreen;

        // prevent infinite loading screen
        if (diag_tickTime > _timeout) then {
            private _msg = format ["Loading handlers did not complete: %1", _handlers apply {_x get "name"}];
            _msg call vgm_g_fnc_logError;

            // show error to admins and let them get into the mission
            if (isServer || {call BIS_fnc_admin > 0} || {call BIS_fnc_isDebugConsoleAllowed}) exitWith {
                _msg spawn {
                    waitUntil {!isNull call BIS_fnc_displayMission};
                    [_this, "Error"] call BIS_fnc_GUImessage;
                };
                break;
            };

            // kick normal player out of the mission
            failMission "TimedOut";
            break;
        };

        uiSleep 0.1;
    };

    "vgm_loading" call BIS_fnc_endLoadingScreen;
};
