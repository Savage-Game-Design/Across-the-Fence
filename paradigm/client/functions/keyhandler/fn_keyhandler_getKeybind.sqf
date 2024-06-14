/*
    File: fn_keyhandler_getKeybind.sqf
    Author:  Savage Game Design
    Public: Yes

    Description:
        Retrieves the keybind currently associated with a particular action.

    Parameter(s):
        _actionName - name of keybind action [STRING]

    Returns:
        Keybind data structure, as described in para_c_fnc_keyhandler_init [HASHMAP]

    Example(s):
        ["para_keydown_enable_selector"] call para_c_fnc_keyhandler_getKeyBind;
*/

params ["_actionName"];

([] call vgm_c_fnc_keyhandler_getSavedKeybinds) get _actionName
