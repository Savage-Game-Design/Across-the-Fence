/*
    File: fn_bf_veh_spawn_create_vehicle_rehandler.sqf
    Author:  Savage Game Design
    Public: No

    Description:
        Rehandler callback from the client to create a vehicle.

    Parameter(s):
		_buildingObject - Building object to spawn a vehicle at [OBJECT]
		_vehicleType - Config name of the vehicle type, as defined in the building's features section [STRING]

    Returns:
		None

    Example(s):
		["bf_veh_spawn_create_vehicle", [_buildingObject, "vn_vehicleClass"]] call para_c_fnc_call_on_server
*/

params ["_buildingObject", "_vehicleType", "_classType"];

//Do a basic distance check - don't really care about exact distance.
//Just want to make sure the player isn't on the other side of the map.
if (_player distance _buildingObject > 50) exitWith
{
  diag_log format ["Paradigm: Warning: Player attempted to spawn vehicle from far away: %1, %2", _player, _player distance _buildingObject];
};

//TODO - Side check here.
[_player, _buildingObject, _vehicleType, _classType] call para_s_fnc_bf_veh_spawn_create_vehicle;
