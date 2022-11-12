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
	private _ctrlKeybinds = _display displayCtrl PARA_KEYBINDINGSMENU_KEYBINDS_IDC;
	private _usedKeys = _display getVariable ["usedKeys", []];
	for "_i" from 0 to (lnbSize _ctrlKeybinds select 0) -1 do {
		private _keyBind = [_ctrlKeybinds lbData _i];
		_keyBind append (_usedKeys select (_ctrlKeybinds lbValue _i));
		_keyBind call para_c_fnc_change_key_bind;
	};
};
