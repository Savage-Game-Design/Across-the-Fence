/*
    File: fn_keyhandler_addDisplayActionHandler.sqf
    Author: Savage Game Design
    Date: 2024-05-10
    Last Update: 2024-05-10
    Public: Yes

    Description:
        Adds an action handler that can be triggered only from that specific display.

    Parameter(s):
        _display - Display to register the handler to [DISPLAY]
        _actionName - Action to register for [STRING]
        _handler - Code to fire [CODE]

    Returns:
        Nothing

    Example(s):
        ["MyAction", para_c_fnc_doThing] call para_c_fnc_keyhandler_addGeneralActionHandler;
 */

params ["_display", "_actionName", "_handler"];

private _handlers = _display getVariable ["para_c_keyhandler_handlers", createHashmap];
private _actionHandlers = _handlers getOrDefault [_actionName, [], true];

_actionHandlers pushBack _handler;

_display setVariable ["para_c_keyhandler_handlers", _handlers];
[_display] call para_c_fnc_keyhandler_hookDisplayKeyEvents;
