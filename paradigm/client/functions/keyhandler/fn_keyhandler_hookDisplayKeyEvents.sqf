/*
    File: fn_keyhandler_hookDisplayEvents.sqf
    Author: Savage Game Design
    Date: 2024-05-10
    Last Update: 2024-05-10
    Public: No

    Description:
        Makes the keyhandler system listen for KeyDown and KeyUp presses on the given display.

    Parameter(s):
        _display - Display to hook into [DISPLAY]

    Returns:
        Nothing

    Example(s):
        [findDisplay 46] call para_c_fnc_keyhandler_hookDisplayEvents
 */

params ["_display"];

if (_display getVariable ["para_c_keyhandler_keyEventsSetup", false]) exitWith {};

_display displayAddEventHandler ["KeyDown", { [ "KeyDown", _this ] call para_c_fnc_keyhandler_onKeypress }];
_display displayAddEventHandler ["KeyUp", { [ "KeyUp", _this ] call para_c_fnc_keyhandler_onKeypress }];

_display setVariable ["para_c_keyhandler_keyEventsSetup", true];
