/*
	File: fn_optionsMenu_onCheckedChanged.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Handles a Checkbox change.

	Parameter(s):
		_control - Control [CONTROL]
		_newValue - New value [NUMBER]

	Returns: nothing
	
	Example(s): none
*/

params ["_control", "_newValue"];

private _data = _control getVariable "#data";
_data params ["_name", "_configName", "_type", "_default", "_value", "_ctrlName", "_ctrlBackground", "_ctrlGroup"];


#define PARSE_BOOL(N) ([false,true] select N)
private _newValueBool = PARSE_BOOL(_newValue);
private _valueBool = PARSE_BOOL(_value);
private _defaultBool = PARSE_BOOL(_default);
#undef PARSE_BOOL

[_control, _configName, _newValueBool, _valueBool] call para_c_fnc_optionsMenu_handleChange;
_control ctrlSetTooltip format ["Default: %1\nCurrent: %2\nNew: %3", _defaultBool, _valueBool, _newValueBool];
