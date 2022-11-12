/*
	File: fn_arraydict_set.sqf
	Author:  Savage Game Design
	Public: Yes
	
	Description:
		Sets a dictionary key to a given value
	
	Parameter(s):
		_dict - Dictionary to use [ARRAY]
		_key - Key to set [ANY]
		_value - Value to set key to [ANY]
	
	Returns:
		Value set [ANY]
	
	Example(s):
		[_myDict, "test", "value"] call para_g_fnc_arraydict_set;
*/

params ["_dict", "_key", "_value"];

private _keys = _dict select struct_arraydict_m_keys;
private _values = _dict select struct_arraydict_m_values;
private _index = _keys find _key;

if (_index > -1) exitWith {
	_values set [_index, _value];
};

_keys pushBack _key;
_values pushBack _value;