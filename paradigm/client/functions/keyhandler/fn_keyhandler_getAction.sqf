/*
    File: fn_keyhandler_getAction.sqf
    Author:  Savage Game Design
    Public: Yes

    Description:
        Retrieves information on a particular action.

    Parameter(s):
        _actionName - name of keybind action [STRING]

    Returns:
        Action data structure - see para_c_fnc_keyhandler_init [HASHMAP]

    Example(s):
        ["para_keydown_enable_selector"] call para_c_fnc_keyhandler_getAction
*/

params ["_actionName"];

localNamespace getVariable "para_keyhandler_actions" get _actionName
