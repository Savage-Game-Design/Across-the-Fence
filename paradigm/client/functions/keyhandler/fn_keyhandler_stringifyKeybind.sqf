/*
    File: fn_keyhandler_stringifyKeypress.sqf
    Author: Savage Game Design
    Date: 2024-05-05
    Last Update: 2024-07-06
    Public: No

    Description:
        Converts the given keybind to a string.

        Returns the same string as para_c_fnc_keyhandler_stringifyKeypress, if _humanReadable is false.

    Parameter(s):
        _keyBind - Keybind (see para_c_fnc_keyhandler_init) [HASHMAP]
        _humanReadable - If true, uses the human readable key name [BOOLEAN]

    Returns:
        Stringified keybinding, e.g "SHIFT+CTRL+ALT+49"

    Example(s):
        [
            createHashMapFromArray [
                ["dikCode", 49],
                ["shift", false]
            ],
            true
        ] call para_c_fnc_keyhandler_stringifyKeybind;
 */

params ["_keyBind", ["_humanReadable", false]];

private _dikCode = _keyBind get "dikCode";

[
    ["", "SHIFT+"] select (_keyBind getOrDefault ["shift", false]),
    ["", "CTRL+"] select (_keyBind getOrDefault ["ctrl", false]),
    ["", "ALT+"] select (_keyBind getOrDefault ["alt", false]),
    if (_humanReadable) then { [_dikCode] call para_c_fnc_getKeyName } else { _dikCode }
] joinString ""
