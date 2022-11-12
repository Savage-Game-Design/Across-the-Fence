/*
	File: fn_building_is_functional.sqf
	Author:  Savage Game Design
	Public: Yes
	
	Description:
		Checks if a building is currently functional.

	Parameter(s):
		_building - Building to check [NAMESPACE]
	
	Returns:
		Returns true if the building is functional, false otherwise [BOOL]
	
	Example(s):
		[cursorObject getVariable "para_g_building"] call para_g_fnc_building_is_functional
*/

params ["_building"];

private _supplySource = _building getVariable ["para_g_current_supply_source", objNull];

//Return boolean check for functionality
   _supplySource getVariable "para_g_current_supplies" > 0 
&& _building getVariable ["para_g_building_constructed", false]
