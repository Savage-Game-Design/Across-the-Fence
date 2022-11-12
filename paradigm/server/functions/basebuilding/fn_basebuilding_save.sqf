/*
	File: fn_basebuilding_save.sqf
	Author:  Savage Game Design
	Public: Yes
	
	Description:
		Saves all buildings
	
	Parameter(s):
		None
	
	Returns:
		None
	
	Example(s):
		[] call para_s_fnc_basebuilding_save;
*/

private _bases = para_g_bases apply {[_x] call para_s_fnc_base_serialize};
private _buildings = para_l_buildings apply {[_x] call para_s_fnc_building_serialize};

["SET", "basebuilding", [_bases, _buildings]] call para_s_fnc_profile_db;