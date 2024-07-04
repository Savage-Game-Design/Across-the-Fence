/*
    File: fn_wheel_menu_open_with_default_actions.sqf
    Author: Savage Game Design
    Public: No

    Description:
        Called from the keybinding system to toggle the wheel menu.

    Parameter(s):

    Returns:
        True if wheel menu was opened [BOOL]

    Example(s):
		N/A
*/

private _display = uiNamespace getVariable ["vn_wheelmenu", displayNull];

if (isNull _display) exitWith {
    [] call para_c_fnc_wheel_menu_open_keybind;
};

_display closeDisplay 1;
