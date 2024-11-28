/*
    File: fn_loading_preInit.sqf
    Author: Savage Game Design
    Date: 2024-11-22
    Last Update: 2024-11-28
    Public: No

    Description:
        Client preInit function for loading system.
 */

if (!hasInterface) exitWith {};

[true, "OnDisplayRegistered", {
    params ["_display", "_class"];
    if (_class != "RscDisplayLoading") exitWith {};
    with missionNamespace do {"Hooking into loading screen" call vgm_g_fnc_logDebug};

    private _loadingDisplay = _display createDisplay "VGM_DisplayLoading";
    _loadingDisplay setVariable ["VGM_Parent", _display];
}] call BIS_fnc_addScriptedEventHandler;
