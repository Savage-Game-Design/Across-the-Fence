/*
	File: fn_building_disconnect_supply_source.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Disconnects a building from its supply source
	
	Parameter(s):
		_building - Building [NAMESPACE]
	
	Returns:
	None

	Example(s):
	[_building] call para_s_fnc_building_disconnect_supply_source
*/

params ["_building"];

private _buildingSupplyConsumption = getNumber (([_building] call para_g_fnc_get_building_config) >> "supply_consumption");

private _oldSource = _building getVariable ["para_g_current_supply_source", objNull];
if !(isNull _oldSource) then {
	_oldSource setVariable ["para_g_supply_buildings", (_oldSource getVariable "para_g_supply_buildings") - [_building], true];
	//Update the amount of supplies being consumed per second.
	_oldSource setVariable [
		"para_g_supply_consumption_rate", 
		(_oldSource getVariable "para_g_supply_consumption_rate") - _buildingSupplyConsumption, 
		true
	];

	_building setVariable ["para_g_current_supply_source", nil, true];
};