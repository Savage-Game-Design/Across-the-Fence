/*
	File: fn_building_connect_supply_source.sqf
	Author:  Savage Game Design
	Public: Yes
	
	Description:
	Connects a building to a supply source
	
	Parameter(s):
		_building - Building [NAMESPACE]
		_supplySource - Supply source [NAMESPACE]
	
	Returns:
	None

	Example(s):
	[_newSupplySource, _newBuilding] call para_s_fnc_building_connect_supply_source
*/

params ["_building", "_supplySource"];

private _buildingSupplyConsumption = getNumber (([_building] call para_g_fnc_get_building_config) >> "supply_consumption");

[_building] call para_s_fnc_building_disconnect_supply_source;

_building setVariable ["para_g_current_supply_source", _supplySource, true];
_supplySource setVariable ["para_g_supply_buildings", (_supplySource getVariable "para_g_supply_buildings") + [_building], true];

//Update total supply consumption on the supply source
_supplySource setVariable [
	"para_g_supply_consumption_rate", 
	(_supplySource getVariable "para_g_supply_consumption_rate") + _buildingSupplyConsumption, 
	true
];

//Tell any features the amount of supplies has changed.
[
	_building, 
	"onSuppliesChanged", 
	[_building, _supplySource getVariable "para_g_current_supplies"]
] call para_g_fnc_building_fire_feature_event