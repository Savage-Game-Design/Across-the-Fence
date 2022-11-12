/*
	File: fn_keybindingsMenu_editBind.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		LNB was double clicked, activate editing of the assigned key
	
	Parameter(s):
		_ctrlKeybinds - The LNB control [CONTROL]
		_row - Double clicked row [NUMBER]
	
	Returns:
		Nothing
	
	Example(s):
		[_ctrlKeybinds, _row] call para_c_fnc_keybindingsMenu_editBind;
*/
#include "..\..\..\configs\ui\ui_def_base.inc"
//--- Entry was double clicked, edit the currently selected bind
params ["_ctrlKeybinds", "_row"];
[
	_ctrlKeybinds, 
	COLOR_KEYBINDINGS_NORMAL_UNSELECTED, 
	COLOR_KEYBINDINGS_DOUBLEBIND_UNSELECTED, 
	COLOR_KEYBINDINGS_NORMAL_SELECTED
] call para_c_fnc_keybindingsMenu_updateColors;
_ehID = _ctrlKeybinds ctrlAddEventHandler ["KeyDown", format [
	"(_this + [%1]) call para_c_fnc_keybindingsMenu_editBind_input;", 
	_row
]];
_ctrlKeybinds setVariable ["editBindKeyEH", _ehID];
