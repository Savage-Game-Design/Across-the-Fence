/*
	File: fn_keybindingsMenu_editBind_input.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Key was pressed while keybindingsmenu was in editing assigned key mode.
	
	Parameter(s):
		_ctrlKeybinds - LNB [CONTROL]
		_key - DIK code of the pressed key [NUMBER]
		_shift - State of the shift key [BOOL]
		_ctrl - State of the shift key [BOOL]
		_alt - State of the shift key [BOOL]
		_row - The currently selected row in the keybindings LNB [NUMBER]
	
	Returns:
		true (intercepts default key behaviour
	
	Example(s):
		[_ctrlKeybinds, 1, false, false, false, 0] call para_c_fnc_keybindingsMenu_editBind_input;
*/
#include "..\..\..\configs\ui\ui_def_base.inc"
#include "\a3\ui_f\hpp\definedikcodes.inc"

params ["_ctrlKeybinds", "_key", "_shift", "_ctrl", "_alt", "_row"];

private _forbiddenKeys = [DIK_LSHIFT, DIK_LCONTROL, DIK_LMENU];
if (_key in _forbiddenKeys) exitWith {
	//--- Ignore shift, ctrl and alt
	true
};
private _display = ctrlParent _ctrlKeybinds;
_ctrlKeybinds ctrlRemoveEventHandler ["KeyDown", _ctrlKeybinds getVariable ["editBindKeyEH", -1]];
_ctrlKeybinds lnbSetCurSelRow _row;
if (_key != DIK_ESCAPE) then {
	private _usedKeys = _display getVariable ["usedKeys", []];
	_name = [_key] call para_c_fnc_getKeyName;
	if (_alt) then {_name = "ALT+" + _name};
	if (_ctrl) then {_name = "CTRL+" + _name};
	if (_shift) then {_name = "SHIFT+" + _name};
	_ctrlKeybinds lnbSetText [[_row,1], _name];
	_usedKeys set [_ctrlKeybinds lbValue _row, [_key, str _shift, str _ctrl, str _alt]];
	_display setVariable ["usedKeys", _usedKeys];
};
[_ctrlKeybinds] call para_c_fnc_keybindingsMenu_updateColors;
true