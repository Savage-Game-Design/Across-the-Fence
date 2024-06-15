/*
    File: fn_keyhandler_saveKeybind.sqf
    Author: Savage Game Design
    Date: 2024-05-05
    Last Update: 2024-06-15
    Public: No

    Description:
        Saves a keybinding to the profile namespace.

    Parameter(s):
        _actionName - Name of the action [STRING]
        _keyBinding - Keybinding, in the format described in para_c_fnc_keyhandler_init [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [
            "MyAction",
            createHashmapFromArray [
                ["dikCode", 5],
                ["shift", true],
                ["ctrl", false],
                ["alt", false]
            ]
        ] call para_c_fnc_keyhandler_saveKeybind;
 */

params ["_actionName", "_keyBind"];

([] call para_c_fnc_keyhandler_getSavedKeybinds) set [_actionName, _keyBind];

