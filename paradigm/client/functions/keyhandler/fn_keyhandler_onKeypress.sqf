/*
    File: fn_keyhandler_onKeypress.sqf
    Author: Savage Game Design
    Date: 2024-05-05
    Last Update: 2024-05-10
    Public: No

    Description:
        Triggers actions when the key is pressed.

    Parameter(s):
        _pressType - Either "KeyUp" or "KeyDown" [STRING]
        _pressDetails - Infomation on the key pressed, as parameters for para_c_fnc_keyhandler_stringifyKeypress [ARRAY]

    Returns:
        Nothing

    Example(s):
        ["KeyUp", [5, true, false, false]] call para_c_fnc_keyhandler_onKeypress;
 */

params ["_pressType", "_pressDetails"];

private _registeredKeybindings = localNamespace getVariable "para_keyhandler_bindings";

private _bindingToCheck = _pressDetails + [_pressType];

if !(_bindingToCheck in _registeredKeybindings) exitWith { false };

private _actionNamesToFire = _registeredKeybindings getOrDefault [_bindingToCheck, []];

private _registeredActions = localNamespace getVariable "para_keyhandler_actions";
private _actionsToFire = _actionNamesToFire apply {_registeredActions get _x};

// Shouldn't need safety checks, as active keybindings should only refer to registered actions.
{
    [] call (_x get "function")
} forEach _actionsToFire;

true
