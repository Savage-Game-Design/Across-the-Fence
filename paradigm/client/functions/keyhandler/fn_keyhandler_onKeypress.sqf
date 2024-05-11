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
        _pressDetails - Infomation on the key pressed, as given by KeyDown and KeyUp UI events [ARRAY]

    Returns:
        Nothing

    Example(s):
        ["KeyUp", [5, true, false, false]] call para_c_fnc_keyhandler_onKeypress;
 */

params ["_pressType", "_pressDetails"];

private _keysPressed = _pressDetails select [1, 4];
private _registeredKeybindings = localNamespace getVariable "para_keyhandler_bindings";

private _bindingToCheck = _keysPressed + [_pressType];

if !(_bindingToCheck in _registeredKeybindings) exitWith { false };

private _actionNamesToFire = _registeredKeybindings getOrDefault [_bindingToCheck, []];
private _handlers = [];

// Prepare any action handlers registered on this display.
private _display = _pressDetails select 0;
private _displayHandlers = _display getVariable ["para_c_keyhandler_handlers", createHashMap];

{
    _handlers append (_displayHandlers getOrDefault [_x, []]);
} forEach _actionNamesToFire;

// Prepare main display action handlers, if the display has been set up to allow them.
private _mainDisplay = findDisplay 46;
if (_display getVariable ["para_c_keyhandler_enableGeneralActions", false] && _display isNotEqualTo _mainDisplay) then {
    private _mainDisplayHandlers = _mainDisplay getVariable ["para_c_keyhandler_handlers", createHashMap];
    {
        _handlers append (_mainDisplayHandlers getOrDefault [_x, []]);
    } forEach _actionNamesToFire;
};

// Shouldn't need safety checks, as active keybindings should only refer to registered actions.
{
    [] call _x;
} forEach _handlers;

true
