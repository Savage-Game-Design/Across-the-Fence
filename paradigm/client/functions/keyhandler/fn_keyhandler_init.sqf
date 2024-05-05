/*
    File: fn_keyhandler_init.sqf
    Author: Savage Game Design
    Date: 2024-05-05
    Last Update: 2024-05-05
    Public: Yes

    Description:
        Sets up global keybindings.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        N/A - Called in postInit
 */

/*
These are the common data structures used in this system.

Profile namespace data structure
================================
createHashmapFromArray [
    ["ExampleActionName", createHashmapFromArray [
        ["dikCode", 59],
        ["shift", true],
        ["ctrl", true],
        ["alt", true]
    ]]
]

Active keybindings data structure:
=================================
createHashmapFromArray [
    ["CTRL+ALT+SHIFT+T", ["ExampleActionName", "OtherExampleActionName"]]
]

Keybinding registration data structure:
[
    createHashmapFromArray [
        ["name", "ExampleActionName"],
        ["function", {}],
        // Fire on KeyUp instead of KeyDown
        ["onRelease", false],
        ["defaultKey", createHashmapFromArray [
            ["dikCode", DIK_ESCAPE],
            ["shift", true],
            ["ctrl", true],
            ["alt", true]
        ]]
    ]
]
*/

[] spawn {
    waitUntil { sleep 0.1; !(isNull findDisplay 46) };

    private _savedKeybindings = profileNamespace getVariable ["para_c_keyhandler_bindings", createHashMap];
    private _allAvailableActions = [localNamespace, "para_fetch_keyhandler_actions", [], true] call BIS_fnc_callScriptedEventHandler;

    private _registeredKeybindings = createHashmapFromArray [
        ["KeyUp", createHashmap],
        ["KeyDown", createHashMap]
    ];
    private _registeredActions = createHashmap;

    profileNamespace setVariable ["para_c_keyhandler_bindings", _savedKeybindings];
    localNamespace setVariable ["para_keyhandler_bindings", _registeredKeybindings];
    localNamespace setVariable ["para_keyhandler_actions", _registeredActions];

    {
        private _actionName = _x get "name";
        // Any new actions (e.g from gamemode updates) get saved to the profile.
        if !(_actionName in _savedKeybindings) then {
            [_actionName, _x get "defaultKey"] call para_c_fnc_keyhandler_saveKeybind;
        };

        _registeredActions set [_actionName, _x];
    } forEach _allAvailableActions;

    {
        [_x, _y] call para_c_fnc_keyhandler_setKeybind;
    } forEach _savedKeybindings;

    private _display = findDisplay 46;
    _display displayAddEventHandler ["KeyDown", { [ "KeyDown", _this select [1, 4]] call para_c_fnc_keyhandler_onKeypress }];
    _display displayAddEventHandler ["KeyUp", { [ "KeyUp", _this select [1, 4]] call para_c_fnc_keyhandler_onKeypress }];
};
