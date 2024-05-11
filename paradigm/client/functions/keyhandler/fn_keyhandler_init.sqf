#include "\a3\ui_f\hpp\defineDikCodes.inc"

/*
    File: fn_keyhandler_init.sqf
    Author: Savage Game Design
    Date: 2024-05-05
    Last Update: 2024-05-11
    Public: Yes

    Description:
        Sets up global keybindings.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        N/A - Called in postInit
 */

/*
These are the common data structures used in this system.

Profile namespace data structure
================================
createHashmapFromArray [
    ["ExampleActionName", createHashmapFromArray [
        ["dikCode", 59],
        ["shift", true],
        ["ctrl", true],
        ["alt", true]
    ]]
]

Active keybindings data structure:
=================================
createHashmapFromArray [
    ["CTRL+ALT+SHIFT+T", ["ExampleActionName", "OtherExampleActionName"]]
]

Action registration data structure:
=======================================
[
    createHashmapFromArray [
        ["name", "ExampleActionName"],
        ["displayName", "STR_MY_DISPLAY_NAME"],
        // Fire on KeyUp instead of KeyDown
        ["onRelease", false],
        ["defaultKey", createHashmapFromArray [
            ["dikCode", DIK_ESCAPE],
            ["shift", true],
            ["ctrl", true],
            ["alt", true]
        ]]
    ]
]
*/

localNamespace setVariable ["para_c_keyhandler_bannedKeys", [
    DIK_ESCAPE
] createHashMapFromArray []];

private _savedKeybindings = profileNamespace getVariable ["para_c_keyhandler_bindings", createHashMap];
profileNamespace setVariable ["para_c_keyhandler_bindings", _savedKeybindings];

localNamespace setVariable ["para_keyhandler_bindings", createHashMap];

private _registeredActions = localNamespace getVariable ["para_keyhandler_actions", createHashMap];
localNamespace setVariable ["para_keyhandler_actions", _registeredActions];

{
    [_x, _y] call para_c_fnc_keyhandler_setKeybind;
} forEach _savedKeybindings;
