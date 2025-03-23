/*
    File: fn_keyhandler_registerAction.sqf
    Author: Savage Game Design
    Date: 2024-05-11
    Last Update: 2024-06-15
    Public: Yes

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

params [["_action", nil, [createHashMap]]];

// If the system isn't initialised, buffer the action registrations until it is
if (isNil { [] call para_c_fnc_keyhandler_getSavedKeybinds }) exitWith {
    private _pendingActionRegistrations = localNamespace getVariable ["para_c_keyhandler_pendingActionRegistrations", []];
    _pendingActionRegistrations pushBack _this;
    localNamespace setVariable ["para_c_keyhandler_pendingActionRegistrations", _pendingActionRegistrations];
};

_this call para_c_fnc_keyhandler_registerActionAfterInit;
