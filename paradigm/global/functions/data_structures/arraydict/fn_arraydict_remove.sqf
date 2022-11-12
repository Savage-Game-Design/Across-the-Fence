/*
	File: fn_arraydict_remove.sqf
	Author:  Savage Game Design
	Public: Yes

	Description:
		Deletes a key from a dictionary

	Parameter(s):
		_dict - Dictionary to use [ARRAY]
		_key - Key to remove [ANY]

	Returns:
		true if value deleted, false otherwise

	Example(s):
		[_myDict, "test"] call para_g_fnc_arraydict_remove;
*/

params ["_dict", "_key", "_value"];

private _keys = _dict select struct_arraydict_m_keys;
private _values = _dict select struct_arraydict_m_values;
private _index = _keys find _key;

if (_index > -1) exitWith {
	_keys deleteAt _index;
	_values deleteAt _index;
	true
};

false