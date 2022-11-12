/*
	File: fn_bf_veh_spawn_request_vehicle_spawn.sqf
	Author:  Savage Game Design
	Public: Yes

	Description:
		Requests a specific building spawn a specific vehicle.

	Parameter(s):
		_buildingObject - Building object to request spawn from [OBJECT]
		_vehicleConfig - Config for the vehicle to spawn, taken from the buildables config [CONFIG]

	Returns:
		None

	Example(s):
		[
			_buildingObject,
			([_building] call para_g_fnc_get_building_config) >> "features" >> "vehicle_spawning" >> "vehicles" >> "myVehicle"
		] call para_c_fnc_bf_veh_spawn_request_vehicle_spawn;
*/

params ["_buildingObject", "_vehicleType", "_classType"];

["bf_veh_spawn_create_vehicle", [_buildingObject, _vehicleType, _classType]] call para_c_fnc_call_on_server;
