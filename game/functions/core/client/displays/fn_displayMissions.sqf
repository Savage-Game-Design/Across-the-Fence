/*
    File: fn_displayMissions.sqf
    Author: Terra
    Date: 2023-02-03
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
    case "initTargets":{
        _params params ["_ctrlTargets"];
        for "_i" from 0 to 10 do {
            _ctrlTargets lbAdd format ["Test %1", _i];
        };
    };
    case "generate": {
        _params params ["_ctrlGenerate"];
    };
    case "onUnload":{
        _params params ["_display", "_exitCode"];
    };
};
