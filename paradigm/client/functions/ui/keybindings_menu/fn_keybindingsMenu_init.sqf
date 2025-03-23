/*
	File: fn_keybindingsMenu_init.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Adds a button to the escape menu which opens the keybindings menu.

	Parameter(s):
		None

	Returns:
		Nothing

	Example(s):
		[] call para_c_fnc_keybindingsMenu_init;
*/

#include "..\..\..\configs\ui\ui_def_base.inc"

[missionNamespace, "OnGameInterrupt", {
	params ["_display"];

	// Keybindings
	_newBtn = _display ctrlCreate ["para_RscButtonMenu", -1];
	_newBtn ctrlSetPosition [safeZoneX + UIW(1), safeZoneY + UIH(1), UIW(15), UIH(1)];
	_newBtn ctrlCommit 0;
	_newBtn ctrlSetText localize "STR_PARA_KEYBINDINGS_MENU_BUTTON";
	_newBtn ctrlAddEventHandler ["ButtonClick",{
		params ["_btn"];
		_escDisplay = ctrlParent _btn;
		_escDisplay createDisplay "para_RscDisplayKeybindingsMenu";
	}];
}] call BIS_fnc_addScriptedEventHandler;
