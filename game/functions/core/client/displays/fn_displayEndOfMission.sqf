/*
    File: game/functions/core/client/displays/fn_displayEndOfMission.sqf
    Author: Savage Game Design
    Date: 2023-09-25
    Last Update: 2023-09-25
    Public: No

    Description:
            UI script for the End Of Mission UI.

    Parameter(s):
            _mode - One of the switch cases [STRING]
            _this - Arguments for the passed case [ARRAY]

    Returns:
            Nothing [NIL]

    Example(s):
            ["onLoad", [_display]] call vgm_c_fnc_displayEndOfMission;
*/
params ["_mode", "_this"];
switch _mode do {
    case "onLoad":{
        params ["_display"];
    };
};
