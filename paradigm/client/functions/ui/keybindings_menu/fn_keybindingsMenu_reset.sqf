/*
	File: fn_keybindingsMenu_reset.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Reset the key assignments to default in the keybindings menu.
	
	Parameter(s):
		_ctrlReset - Reset button [CONTROL]
	
	Returns:
		Nothing
	
	Example(s):
		[_ctrlReset] call para_c_fnc_keybindingsMenu_reset;
*/
#include "..\..\..\configs\ui\ui_def_base.inc"

params ["_ctrlReset"];

private _display = ctrlParent _ctrlReset;
private _ctrlKeybinds = _display displayCtrl PARA_KEYBINDINGSMENU_KEYBINDS_IDC;
private _cfgKeys = missionConfigFile >> "gamemode" >> "keys";
private _usedKeys = [];
for "_i" from 0 to (((lnbSize _ctrlKeybinds)#0) -1) do {
	private _actionName = _ctrlKeybinds lbData _i;
	private _keyDefault = getNumber(_cfgKeys >> _actionName >> "defaultKey");
	private _keyName = [_keyDefault] call para_c_fnc_getKeyName;
	_keyAlt = getText(_cfgKeys>>_actionName>>"alt");
	_keyCtrl = getText(_cfgKeys>>_actionName>>"ctrl");
	_keyShift = getText(_cfgKeys>>_actionName>>"shift");

	if (_keyAlt == "true") then {_keyName = "ALT+" + _keyName};
	if (_keyCtrl == "true") then {_keyName = "CTRL+" + _keyName};
	if (_keyShift == "true") then {_keyName = "SHIFT+" + _keyName};
	_ctrlKeybinds lnbSetText [[_i, 1], _keyName];
	_usedKeys pushBack [_keyDefault, _keyShift, _keyCtrl, _keyAlt];
};
_display setVariable ["usedKeys", _usedKeys];
[_ctrlKeybinds] call para_c_fnc_keybindingsMenu_updateColors;