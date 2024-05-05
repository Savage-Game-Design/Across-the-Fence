/*
    File: fn_keyhandler_stringifyKeypress.sqf
    Author: Savage Game Design
    Date: 2024-05-05
    Last Update: 2024-05-05
    Public: No

    Description:
        Converts the given keypress to a string.

        Parameters are listed in the same order as engine KeyDown and KeyUp event handlers.

    Parameter(s):
        _dikCode - Code of the key [NUMBER]
        _shift - Shift modifier active [BOOLEAN]
        _ctrl - Ctrl modifier active [BOOLEAN]
        _alt - Alt modifier active [BOOLEAN]

    Returns:
        Stringified keybinding, e.g "SHIFT+CTRL+ALT+49"

    Example(s):
        [DIK_ESCAPE, true, true, true] call para_c_fnc_keyhandler_stringifyKeypress;
 */

params ["_dikCode", ["_shift", false], ["_ctrl", false], ["_alt", false]];

[
    ["", "SHIFT+"] select _shift,
    ["", "CTRL+"] select _ctrl,
    ["", "ALT+"] select _alt,
    _dikCode
] joinString ""
