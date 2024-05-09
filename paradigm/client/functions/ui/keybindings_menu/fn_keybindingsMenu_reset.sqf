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

private _currentKeybinds = _display getVariable ["currentKeybinds", createHashMap];

for "_i" from 0 to (((lnbSize _ctrlKeybinds)#0) -1) do {
	private _actionName = _ctrlKeybinds lbData _i;
    private _originalKeybind = ([_actionName] call para_c_fnc_keyhandler_getAction) get "defaultKey";

	_ctrlKeybinds lnbSetText [[_i, 1], [_originalKeybind, true] call para_c_fnc_keyhandler_stringifyKeybind];
    _currentKeybinds set [_actionName, _originalKeybind];
};

[_ctrlKeybinds] call para_c_fnc_keybindingsMenu_updateColors;
