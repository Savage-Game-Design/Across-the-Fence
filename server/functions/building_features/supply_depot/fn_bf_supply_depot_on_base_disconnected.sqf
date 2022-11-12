/*
	File: fn_bf_supply_depot_on_base_disconnected.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Removes supply depot effects.

	Parameter(s):
		_building - Supply depot [NAMESPACE]
		_base - Base to disconnect from [NAMESPACE]

	Returns:
		None

	Example(s):
		See building features config
*/

params ["_building", "_base"];

private _supplySource = _base getVariable ["para_g_supply_source", objNull];
private _currentCap = _supplySource getVariable "para_g_supply_capacity";
private _config = [_building] call para_g_fnc_get_building_config;
private _supplyRemoved = getNumber (_config >> "features" >> "supply_depot" >> "supplyChange");
private _size = _currentCap - _supplyRemoved;

_supplySource setVariable ["para_g_supply_capacity", _size, true];
