/*
	File: fn_bf_wreck_recovery_on_building_deleted.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Initialization script for wreck recovery buildings
	
	Parameter(s):
		_building - The building object that was used to trigger the recovery [OBJECT]
	
	Returns:
		_building or -1 if unsuccessful.

	Example(s):
		[_building] call para_s_fnc_bf_wreck_recovery_on_building_deleted;
*/

params ["_building"];

para_s_bf_wreck_recovery_buildings deleteAt (para_s_bf_wreck_recovery_buildings find _building);
