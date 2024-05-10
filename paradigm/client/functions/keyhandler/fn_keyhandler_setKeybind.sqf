/*
    File: fn_keyhandler_setKeybind.sqf
    Author: Savage Game Design
    Date: 2024-05-05
    Last Update: 2024-05-10
    Public: Yes

    Description:
        Updates an action's keybinding with a new value.

    Parameter(s):
        _actionName - Name of the action [STRING]
        _keyBind - Keybinding, in the format described in para_c_fnc_keyhandler_init [HASHMAP]

    Returns:
        Whether keybinding was successful [BOOLEAN]

    Example(s):
        [
            "MyAction",
            createHashmapFromArray [
                ["dikCode", 5],
                ["shift", true],
                ["ctrl", false],
                ["alt", false]
            ]
        ] call para_c_fnc_keyhandler_setKeybind;
 */

params ["_actionName", "_keyBind"];

private _registeredActions = localNamespace getVariable "para_keyhandler_actions";
private _registeredKeybindings = localNamespace getVariable "para_keyhandler_bindings";
private _bannedKeys = localNamespace getVariable "para_c_keyhandler_bannedKeys";

private _action = _registeredActions get _actionName;

if (isNil "_action" || (_keyBind get "dikCode") in _bannedKeys) exitWith { false };

private _pressType = ["KeyDown", "KeyUp"] select (_action getOrDefault ["onRelease", false]);

private _newKeypress = [_keyBind] call para_c_fnc_keyhandler_keybindToKeypress;
_newKeypress pushBack _pressType;

private _oldKeybind = [_actionName] call para_c_fnc_keyhandler_getKeybind;

// Remove the old keybinding.
if !(isNil "_oldKeybind") then {
    private _oldKeypress = [_oldKeybind] call para_c_fnc_keyhandler_keybindToKeypress;
    _oldKeypress pushBack _pressType;

    private _actionsForOldBinding = _registeredKeybindings getOrDefault [_oldKeypress, []];
    _actionsForOldBinding deleteAt (_actionsForOldBinding find _actionName);

    // If the old key has no more bound actions, remove it so we can save some processing in keypresses.
    if (count _actionsForOldBinding <= 0) then {
        _registeredKeybindings deleteAt _oldKeypress;
    };
};

_registeredKeybindings
    getOrDefault [_newKeypress, [], true]
    pushBack _actionName;

[_actionName, _keyBind] call para_c_fnc_keyhandler_saveKeybind;
