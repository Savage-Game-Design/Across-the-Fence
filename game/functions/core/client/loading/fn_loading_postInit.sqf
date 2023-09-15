/*
    File: fn_loading_postInit.sqf
    Author: Savage Game Design
    Date: 2023-09-08
    Last Update: 2023-09-15
    Public: No

    Description:
        Client postInit function for loading system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

["vgm_loading", "", "VGM_DisplayLoading"] call BIS_fnc_startLoadingScreen;
localize "STR_LOADING" call vgm_c_fnc_loading_setText;
0 call BIS_fnc_progressLoadingScreen;

private _handlers = missionNamespace getVariable ["vgm_loading_handlers", []];
[_handlers] spawn {
    params ["_handlers"];

    private _total = count _handlers;
    while {count _handlers > 0} do {
        {
            if (call (_x get "handler")) then {
                _handlers deleteAt _forEachIndex;
            };
        } forEachReversed _handlers;

        format [
            "%1... %2",
            localize "STR_LOADING",
            (_handlers apply {_x get "name"}) joinString endl
        ] call vgm_c_fnc_loading_setText;

        (1 - (count _handlers / _total)) call BIS_fnc_progressLoadingScreen;
        uiSleep 0.1;
    };

    "vgm_loading" call BIS_fnc_endLoadingScreen;
};
