/*
    File: fn_keyhandler_registerAction.sqf
    Author: Savage Game Design
    Date: 2024-05-11
    Last Update: 2024-06-14
    Public: No

    Description:
        Registers a new action with the keybinding system, able to be triggered by a keypress.

    Parameter(s):
        _action - See para_c_fnc_keyhandler_init for data structure [HashMap]

    Returns:
        Nothing

    Example(s):
        // See para_c_fnc_keyhandler_init for structure of _myActionHashMap
        [_myActionHashMap] call para_c_fnc_keyhandler_registerAction;
 */

params ["_action"];

private _registeredActions = localNamespace getVariable ["para_keyhandler_actions", createHashMap];

private _actionName = _action get "name";

// Any new actions (e.g from gamemode updates) get saved to the profile.
private _savedKeybindings = [] call vgm_c_fnc_keyhandler_getSavedKeybinds;
if !(_actionName in _savedKeybindings) then {
    [_actionName, _action get "defaultKey"] call para_c_fnc_keyhandler_saveKeybind;
};

_action set ["localizedDisplayName", (_action get "displayName") call para_c_fnc_localize];
_registeredActions set [_actionName, _action];

localNamespace setVariable ["para_keyhandler_actions", _registeredActions];
