/*
	File: fn_keybindingsMenu_updateColors.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Change the colors of the LNB entries.
	
	Parameter(s):
		_ctrlKeybinds - LNB [CONTROL]
		_defaultColor - Default color of the listbox entry [ARRAY in format COLOR, defaults to [1,1,1,1]]
		_doubleColor - Color of double bound listbox entries [ARRAY in format COLOR, defaults to [1,0,0,1]]
		_selColor - Color of the currently selected lnb entry [ARRAY in format COLOR, defaults to _defaultColor]
	
	Returns:
		Nothing
	
	Example(s):
		[_ctrlKeybinds] call para_c_fnc_keybindingsMenu_updateColors;
		[_ctrlKeybinds, [1,1,1,0.5], [1,0,0,0.5]] call para_c_fnc_keybindingsMenu_updateColors;
*/
#include "..\..\..\configs\ui\ui_def_base.inc"

params ["_ctrlKeybinds", ["_defaultColor", COLOR_KEYBINDINGS_NORMAL_SELECTED], ["_doubleColor", COLOR_KEYBINDINGS_DOUBLEBIND_SELECTED]];

private _selColor = param[3, _defaultColor];
private _display = ctrlParent _ctrlKeybinds;
private _usedKeys = _display getVariable ["usedKeys", []];
private _noDuplicates = true;
for "_i" from 0 to ((lnbSize _ctrlKeybinds select 0) -1) do {
	private _id = _ctrlKeybinds lbValue _i;
	_keyParams = _usedKeys select _id;
	private _setColor = if ({_x isEqualTo _keyParams} count _usedKeys > 1) then {
		_noDuplicates = false;
		_doubleColor
	} else {
		_defaultColor
	};
	if (_i == lnbCurSelRow _ctrlKeybinds && _setColor isEqualTo _defaultColor) then {
		_setColor = _selColor;
	};
	for "_j" from 0 to 1 do{
		_ctrlKeybinds lnbSetColor [[_i, _j], _setColor];
	};
};
_ctrlOK = _display displayCtrl 1;
_ctrlOK ctrlEnable _noDuplicates;