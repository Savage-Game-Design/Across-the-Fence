/*
    File: fn_keyhandler_keybindToKeypress.sqf
    Author: Savage Game Design
    Date: 2024-05-05
    Last Update: 2024-05-10
    Public: Yes

    Description:
        Converts the given keybind HashMap to a keypress array.

    Parameter(s):
        _keyBind - Keybind (see para_c_fnc_keyhandler_init) [HASHMAP]

    Returns:
        Keypress array that matches the binding.
        I.e - The parameters from "KeyDown" handler that would trigger this binding. [ARRAY]

    Example(s):
        [
            createHashMapFromArray [
                ["dikCode", 49],
                ["shift", false]
            ]
        ] call para_c_fnc_keyhandler_keybindToKeypress;
 */

params ["_keyBind"];

[
    _keyBind get "dikCode",
    _keyBind getOrDefault ["shift", false],
    _keyBind getOrDefault ["ctrl", false],
    _keyBind getOrDefault ["alt", false]
]
