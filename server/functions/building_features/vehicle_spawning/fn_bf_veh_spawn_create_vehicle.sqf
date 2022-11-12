/*
    File: fn_bf_veh_spawn_create_vehicle.sqf
    Author:  Savage Game Design
    Public: Yes

    Description:
		Creates a vehicle by consuming supplies.

    Parameter(s):
		_requester - Player requesting vehicle [OBJECT]
		_buildingObject - Building object to create vehicle at [OBJECT]
		_vehicleType - Type of vehicle to create [STRING]

    Returns:
		Vehicle created or objNull if it couldn't be created [OBJECT]

    Example(s):
		//TODO
*/

params ["_requester", "_buildingObject", "_vehicleType", "_classType"];

//TODO - Restrict to vehicles of the side that owns the building.

private _building = _buildingObject getVariable ["para_g_building", objNull];

if (isNull _building) exitWith
{
	diag_log format ["Paradigm: Warning: Attempted to create vehicle from object with no building %1", _buildingObject];
};

if !([_building] call para_g_fnc_building_is_functional) exitWith
{
	["BuildingNonFunctional", []] remoteExec ["para_c_fnc_show_notification", _requester];
};

private _config = [_building] call para_g_fnc_get_building_config;
private _featureConfig = (_config >> "features" >> "vehicle_spawning");
if (!isClass _featureConfig) exitWith
{
	diag_log format ["Paradigm: Warning: Attempted to create vehicle from building with no spawning feature: %1", configName _config];
};

private _nextSpawnTime = _building getVariable ["para_s_bf_veh_spawn_next_spawn_time", 0];
if (_nextSpawnTime > serverTime) exitWith
{
	["VehicleSpawnCooldown", [((_nextSpawnTime - serverTime) / 60) toFixed 1]] remoteExec ["para_c_fnc_show_notification", _requester];
};

private _spawningConfig = (_featureConfig >> "vehicle_class" >> _classType >> _vehicleType);

if (!isClass _spawningConfig) exitWith
{
	diag_log format ["Paradigm: Warning: Attempted to create vehicle of type %1 at building that doesn't support it %2", _vehicleType, configName _config];
};
private _cost = getArray (_spawningConfig >> "cost") select 0 select 1;
private _cooldown = getNumber (_spawningConfig >> "cooldown");

private _modelSpawnPos = getArray (_featureConfig >> "spawnPositionModelSpace");
private _spawnDir = getNumber (_featureConfig >> "spawnDirectionModelSpace");
private _spawnPosAGL = _buildingObject modelToWorld _modelSpawnPos;

if (count (_spawnPosAGL nearEntities 10 select {!(_x isKindOf "Animal")}) > 0) exitWith
{
	["SpawnPositionBlocked", []] remoteExec ["para_c_fnc_show_notification", _requester];
};

private _isShip = _vehicleType isKindOf "Ship";
private _isWater = surfaceIsWater _spawnPosAGL;
//if trying to spawn boats on land or cars on sea
if ((_isShip || _isWater) && !(_isShip && _isWater)) exitwith
{
	["VehicleSpawnIncorrect", []] remoteExec ["para_c_fnc_show_notification", _requester];
};

private _usedSupplies = [_building, _cost] call para_s_fnc_building_consume_supplies;

if !(_usedSupplies) exitWith
{
	["InsufficientResources", []] remoteExec ["para_c_fnc_show_notification", _requester];
};

_building setVariable ["para_s_bf_veh_spawn_next_spawn_time", serverTime + _cooldown];

//Create vehicle.
private _vehicle = [_vehicleType, [0,0,1000], [], 0, "CAN_COLLIDE"] call para_g_fnc_create_vehicle;
_vehicle setDir (getDir _buildingObject + _spawnDir);
_spawnPosAGL set [2, 0.5];
if (_isShip) then {
	_vehicle setPosASL _spawnPosAGL;
} else {
	_vehicle setPos _spawnPosAGL;
};

_vehicle
