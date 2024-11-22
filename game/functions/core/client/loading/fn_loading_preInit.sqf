/*
    File: fn_loading_preInit.sqf
    Author: Savage Game Design
    Date: 2024-11-22
    Last Update: 2024-11-22
    Public: No

    Description:
        Client preInit function for loading system.
 */

if (!hasInterface) exitWith {};

[true, "OnDisplayRegistered", {
    params ["_display", "_class"];
    if (_class != "RscDisplayLoading") exitWith {};
    ["Hooking into loading screen"] call vgm_g_fnc_logInfo;

    [_display createDisplay "VGM_DisplayLoading"] spawn {
        params ["_display"];
        private _ctrlProgress = _display displayCtrl 104;
        waitUntil {
            private _progress = (uiNamespace getVariable ["BIS_fnc_progressloadingscreen_progress", 0]);
            _ctrlProgress progressSetPosition _progress;

            isNull _display // return
        };
    };
}] call BIS_fnc_addScriptedEventHandler;
