/*
	File: fn_spawning_get_squad_composition.sqf
	Author:  Savage Game Design
	Public: Yes
	
	Description:
		Retrieves the units that should be in a squad of a given type, side and size.
	
	Parameter(s):
		_type - Type of squad. [STRING]
		_side - Side the squad should be on [SIDE]
		_size - Size of the squad [NUMBER]
	
	Returns:
		Array of unit class names, with _size members [ARRAY]
	
	Example(s):
		["PATROL", west, 5] call para_g_fnc_spawning_get_squad_composition
*/

params ["_type", "_side", "_size", ["_pos", []]];

//Call and return the interop func.
_this call para_interop_fnc_get_squad_composition;