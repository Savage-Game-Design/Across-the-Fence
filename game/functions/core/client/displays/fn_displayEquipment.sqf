/*
    File: P:\SGD\Tour-of-Duty\game\functions\core\client\displays\fn_displayEquipment.sqf
    Author: Savage Game Design
    Date: 2023-07-11
    Last Update: 2023-07-11
    Public: No

    Description:
            Adds funcionality to the Equipment UI

    Parameter(s):
            _mode - Event [STRING]

    Returns:
            nil [NOTHING]

    Example(s):
            [] call vgm_c_fnc_displayEquipment;
*/
#include "macros.inc"
params ["_mode", "_params"];
switch _mode do {
    case "onLoad":{
        _params params ["_display"];
    };
};
