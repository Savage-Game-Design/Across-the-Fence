/*
	File: fn_arraydict_get.sqf
	Author:  Savage Game Design
	Public: Yes
	
	Description:
		Retrieves a value from a dictionary.
	
	Parameter(s):
		_dict - Dictionary to retrieve value from [ARRAY]
		_key - Key to retrieve [ANY]
		_defaultValue - Default value to return if key does not exist. [ANY]
	
	Returns:
		Value if present in the dictionary, default Value if provided and value is nil, nil otherwise. [ANY]
	
	Example(s):
		[_myDict, "test", "default"] call para_g_fnc_arraydict_get;
*/

params ["_dict", "_key", "_value"];

private _keys = _dict select struct_arraydict_m_keys;
private _values = _dict select struct_arraydict_m_values;

private _index = _keys find _key;

if (_index > -1) exitWith {
	_values select _index
};

if !(isNil "_value") exitWith {
	_value
};