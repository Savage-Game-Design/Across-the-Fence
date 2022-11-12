/*
	File: fn_keybindingsMenu_onLoad.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		onLoad UIEH function for the keybindings menu.
	
	Parameter(s):
		_display - Keybindings menue UI [DISPLAY]
	
	Returns:
		Nothing
	
	Example(s):
		[_display] call para_c_fnc_keybindingsMenu_onLoad;
*/

#include "..\..\..\configs\ui\ui_def_base.inc"

params ["_display"];
_ctrlKeybinds = _display displayCtrl PARA_KEYBINDINGSMENU_KEYBINDS_IDC;
//--- get all actions from config:
_keyActions = "getNumber(_x >> 'access') > 0" configClasses (missionConfigFile >> "gamemode" >> "keys");
_usedKeys = [];
_keyActions apply {
	_actionName = configName _x;
	_actionDisplayname = getText(_x >> "displayName");
	private _key_bind = [_actionName] call para_c_fnc_get_key_bind;
	_key_bind params ["_keyID", "_keyShift", "_keyCtrl", "_keyAlt"];
	_usedKeys pushBack _key_bind;
	//--- Check if user set custom key:
	_keyID = _key_bind param[0,""];
	_keyname = [_keyID] call para_c_fnc_getKeyName;
	//--- Handle the ListNBox
	if (_keyAlt == "true") then {_keyname = "ALT+" + _keyname};
	if (_keyCtrl == "true") then {_keyname = "CTRL+" + _keyname};
	if (_keyShift == "true") then {_keyname = "SHIFT+" + _keyname};
	_row = _ctrlKeybinds lnbAddRow [_actionDisplayname, _keyname];
	_ctrlKeybinds lbSetData [_row, _actionName];
	_ctrlKeybinds lbSetValue [_row, count _usedKeys -1];
};
_display setVariable ["usedKeys", _usedKeys];
//--- UIEH for controls:
_ctrlKeybinds ctrlAddEventHandler ["LBDblClick", para_c_fnc_keybindingsMenu_editBind];
_ctrlReset = _display displayCtrl PARA_KEYBINDINGSMENU_RESET_IDC;
_ctrlReset ctrlAddEventHandler ["ButtonClick", para_c_fnc_keybindingsMenu_reset];