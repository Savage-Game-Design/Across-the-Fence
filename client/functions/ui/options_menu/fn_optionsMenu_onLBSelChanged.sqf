/*
	File: fn_optionsMenu_onLBSelChanged.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Handles a Listbox/Combobox change.

	Parameter(s):
		_control - Control [CONTROL]
		_newValue - New value [NUMBER]

	Returns: nothing
	
	Example(s): none
*/

params ["_control", "_newValue"];

private _data = _control getVariable "#data";
_data params ["_name", "_configName", "_type", "_default", "_value", "_ctrlName", "_ctrlBackground", "_ctrlGroup", "_values"];

[_control, _configName, _newValue, _value] call para_c_fnc_optionsMenu_handleChange;

_control ctrlSetTooltip format ["Default: %1\nCurrent: %2\nNew: %3", _values#_default, _values#_value, _values#_newValue];
