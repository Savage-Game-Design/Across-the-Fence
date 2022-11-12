/*
	File: fn_building_connect_base.sqf
	Author:  Savage Game Design
	Public: Yes
	
	Description:
		Makes a building part of a base.
	
	Parameter(s):
		_building - Building to connect [NAMESPACE]
		_base - Base to connect building to [NAMESPACE]

	Returns:
		Function reached the end [BOOL]
	
	Example(s):
	[_building, _base] call para_g_fnc_building_connect_base
*/
params ["_building", "_base"];

_base setVariable ["para_g_buildings", (_base getVariable "para_g_buildings") + [_building], true];

_building setVariable ["para_g_base", _base, true];

//Set the building to use the bases' supply source
[_building, _base getVariable "para_g_supply_source"] call para_s_fnc_building_connect_supply_source;

[_building, "onBaseConnected", [_building, _base]] call para_g_fnc_building_fire_feature_event;