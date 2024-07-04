/*
	File: fn_keybindingsMenu_onUnload.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		onUnload UIEH for the keybindings menu.

	Parameter(s):
		_display - Keybindings menu display [DISPLAY]
		_exitCode - The way the display was closed (1: Confirm) [NUMBER]

	Returns:
		Nothing

	Example(s):
		[_display, 1] call para_c_fnc_keybindingsMenu_onUnload;
*/

#include "..\..\..\configs\ui\ui_def_base.inc"

params ["_display", "_exitCode"];

if (_exitCode == 1) then {
	//--- OK, save settings
    private _currentKeybinds = _display getVariable ["currentKeybinds", createHashMap];

    {
        [_x, _y] call para_c_fnc_keyhandler_setKeybind;
    } forEach _currentKeybinds;

    // Ensure changes are persisted to disk.
    saveProfileNamespace;
};
