/*
    File: fn_ron_fadeScreen.sqf
    Author: Atlas
    Date: 2026-03-06
    Last Update: 2026-03-06
    Public: No

    Description:
        Fades the screen to/from black for the RON cinematic.

    Parameter(s):
        _toBlack - true = fade to black, false = fade from black [BOOL]

    Returns:
        Nothing

    Example(s):
        [true] call vgm_c_fnc_ron_fadeScreen;
        [false] call vgm_c_fnc_ron_fadeScreen;
 */

params ["_toBlack"];

if (!hasInterface) exitWith {};

if (_toBlack) then {
    cutText ["", "BLACK OUT", 2];
} else {
    titleText ["", "PLAIN"];
    cutText ["", "BLACK IN", 3];
};
