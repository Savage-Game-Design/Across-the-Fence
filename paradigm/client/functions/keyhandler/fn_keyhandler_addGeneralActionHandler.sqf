/*
    File: fn_keyhandler_addGeneralActionHandler.sqf
    Author: Savage Game Design
    Date: 2024-05-10
    Last Update: 2024-05-10
    Public: Yes

    Description:
        Adds an action handler that can be triggered at any point during gameplay.

    Parameter(s):
        _actionName - Action to register for [STRING]
        _handler - Code to fire [CODE]

    Returns:
        Nothing

    Example(s):
        ["MyAction", para_c_fnc_doThing] call para_c_fnc_keyhandler_addGeneralActionHandler;
 */

private _display = findDisplay 46;

if (isNull _display) exitWith {
    // Display isn't ready yet - wait until its loaded, then register the handler.
    _this spawn {
        private _display = displayNull;
        waitUntil {
            sleep 0.1;
            _display = findDisplay 46;
            !(isNull _display)
        };

        ([_display] + _this) call para_c_fnc_keyhandler_addDisplayActionHandler;
    };
};

([_display] + _this) call para_c_fnc_keyhandler_addDisplayActionHandler;
