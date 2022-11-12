/*
	File: fn_bf_veh_spawn_on_nonfunctional.sqf
	Author:  Savage Game Design
	Public: No

	Description:
  Called when a vehicle spawn stops functioning. Removes the ability to operate as a master arm station.

	Parameter(s):
  _building - Building that became nonfunctional [OBJECT]

	Returns:
		Function reached the end [BOOL]

	Example(s):
		See building features config
*/
params ["_building"];

private _buildingObject = _building getVariable "para_g_objects";

vn_fnc_masterarm_action_objects deleteAt (vn_fnc_masterarm_action_objects find _buildingObject);
