#include "\a3\ui_f\hpp\defineDikCodes.inc"

/*
    File: fn_keyhandler_init.sqf
    Author: Savage Game Design
    Date: 2024-05-05
    Last Update: 2024-06-15
    Public: Yes

    Description:
        Sets up global keybindings.

    Parameter(s):
        _gamemodeId - Unique ID for the gamemode to avoid keybinding conflicts [STRING]

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

params ["_gamemodeId"];

para_c_keyhandler_gamemodeId = _gamemodeId;
para_c_keyhandler_savedKeybindsProfileKey = format ["para_c_keyhandler_gamemodeBindings_%1", _gamemodeId];

localNamespace setVariable ["para_c_keyhandler_bannedKeys", [
    DIK_ESCAPE
] createHashMapFromArray []];

// Initialise the saved keybinds for this gamemode.
private _savedKeybindings = profileNamespace getVariable [para_c_keyhandler_savedKeybindsProfileKey, createHashMap];
profileNamespace setVariable [para_c_keyhandler_savedKeybindsProfileKey, _savedKeybindings];

localNamespace setVariable ["para_keyhandler_bindings", createHashMap];

private _registeredActions = localNamespace getVariable ["para_keyhandler_actions", createHashMap];
localNamespace setVariable ["para_keyhandler_actions", _registeredActions];

// Register all pending actions, now all critical variables are initialised.
{
    _x call para_c_fnc_keyhandler_registerActionAfterInit;
} forEach (localNamespace getVariable "para_c_keyhandler_pendingActionRegistrations");

{
    [_x, _y] call para_c_fnc_keyhandler_setKeybind;
} forEach _savedKeybindings;

