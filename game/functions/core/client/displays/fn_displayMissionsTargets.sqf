/*
    File: fn_displayMissionsTargets.sqf
    Author: Terra
    Date: 2023-02-06
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
#include "macros.inc"
params ["_mode", "_params"];
switch _mode do {
    case "onLoad":{
        _params params ["_display"];
    };
    case "back": {
        _params params ["_ctrlBack"];
        private _display = ctrlParent _ctrlBack;
        _display closeDisplay IDC_OK;
    };
    case "onUnload":{
        _params params ["_display", "_exitCode"];
    };
};
