/*
    File: fn_keyhandler_enableGeneralActionTriggeringOnDisplay.sqf
    Author: Savage Game Design
    Date: 2024-05-10
    Last Update: 2024-05-11
    Public: No

    Description:
        Some displays block KeyDown and KeyUp handlers on display 46, which is what the general actions listen to.

        This allows those events to propagate to the handlers for display 46.

    Parameter(s):
        _display - Display to enable this feature on [DISPLAY]

    Returns:
        Nothing

    Example(s):
        private _display = createDisplay _myDisplay;
        [_display] call para_c_fnc_keyhandler_enableGeneralActionTriggeringOnDisplay;
 */

params ["_display"];

_display setVariable ["para_c_keyhandler_enableGeneralActions", true];
[_display] call para_c_fnc_keyhandler_hookDisplayKeyEvents;
