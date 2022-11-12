/*
	File: fn_para_RscDisplayKeybindingsMenu.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Handles the functionality para_RscDisplayKeybindingsMenu display.

	Parameter(s):
		see para_c_fnc_ui_initMissionDisplay

	Returns:
		see para_c_fnc_ui_initMissionDisplay

	Example(s):
		see para_c_fnc_ui_initMissionDisplay
*/
#include "..\..\..\configs\ui\ui_def_base.inc"

params ["_mode", "_args", "_class"];
if (_mode == "onLoad") then {
	//--- display onLoad event
	_args call para_c_fnc_keybindingsMenu_onLoad;
} else {
	//--- display onUnload event
	_args call para_c_fnc_keybindingsMenu_onUnload;
};
