/*
	File: fn_action_resupply.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Adds action to ressuply

	Parameter(s):
		_object - Object [Object]

	Returns: nothing

	Example(s):
		call para_c_fnc_action_resupply;
*/

params ["_object"];

[
	_object,
	createHashMapFromArray [
		["condition", {_this call para_g_fnc_is_resupply}],
		["iconPath", "\vn\ui_f_vietnam\ui\wheelmenu\img\icons\vn_ico_mf_resupply_ca.paa"],
		["functionArguments", _object],
		["function", "para_c_fnc_resupply_building_with_crate"],
		["text", localize "STR_vn_mf_resupply"]
	]
] call para_c_fnc_wheel_menu_add_obj_action;
