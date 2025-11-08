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

// Retrieve the active keybind for each action.
private _currentKeybinds = [] call para_c_fnc_keyhandler_getAllKeyBinds;

private _sortedKeybindActions = keys _currentKeybinds;
_sortedKeybindActions sort true;

_sortedKeybindActions apply {
    private _actionName = _x;
    private _bind = _currentKeybinds get _actionName;
	private _actionDisplayName = [_actionName] call para_c_fnc_keyhandler_getAction get "localizedDisplayName";
	private _keyName = [_bind get "dikCode"] call para_c_fnc_getKeyName;

    private _keyDescription = [_bind, true] call para_c_fnc_keyhandler_stringifyKeybind;

	//--- Handle the ListNBox
	_row = _ctrlKeybinds lnbAddRow [_actionDisplayname, _keyDescription];
	_ctrlKeybinds lbSetData [_row, _actionName];
};

_display setVariable ["currentKeybinds", _currentKeybinds];

//--- UIEH for controls:
_ctrlKeybinds ctrlAddEventHandler ["LBDblClick", para_c_fnc_keybindingsMenu_editBind];
_ctrlReset = _display displayCtrl PARA_KEYBINDINGSMENU_RESET_IDC;
_ctrlReset ctrlAddEventHandler ["ButtonClick", para_c_fnc_keybindingsMenu_reset];
