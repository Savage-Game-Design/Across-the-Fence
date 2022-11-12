/*
	File: fn_localize_and_format.sqf
	Author:  Savage Game Design
	Public: Yes
	
	Description:
		Localizes a string, then applies formatting recursively.
		Allows complex string building, from multiple stringtable entries
	
	Parameter(s):
		_varName - Description [DATATYPE, defaults to DEFAULTVALUE]
		_this - Recursive format. If [STRING], behaves like para_c_fnc_localize [ARRAY|STRING]
	
	Returns:
		Localized and formatted [STRING]
	
	Example(s):
		["One %1", ["Two %1", "Three"]] call para_c_fnc_localize_and_format; -Returns "One Two Three"
*/

if (_this isEqualType "") exitWith {
	_this call para_c_fnc_localize
};

private _formatArgs = _this apply {
	if (_x isEqualType []) then {
		_x call para_c_fnc_localize_and_format
	} else {
		_x call para_c_fnc_localize
	}
};

format _formatArgs