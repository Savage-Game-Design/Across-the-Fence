/*
	File: fn_building_create.sqf
	Author:  Savage Game Design
	Public: Yes
	
	Description:
		Creates a new building, composed of one or more objects.
	
	Parameter(s):
		_buildingType - type of building to create [STRING]
		_spawnInfo - Positions to create objects at, in format [posWorld, rotation] [ARRAY]
		_buildProgress - Build progress to create building with [NUMBER]
		_initialSupplies - Initial supplies to put in the building. [NUMBER]
		_buildingId - Unique ID of the building. Leave nil unless loading a building [NUMBER]
	
	Returns:
		Function reached the end [BOOL]
	
	Example(s):
		[parameter] call vn_fnc_myFunction
*/

params ["_buildingType", "_spawnInfo", ["_buildProgress", 0], ["_initialSupplies", 0], "_buildingId"];

//If we're passed a single position entry, put it in an array.
if (_spawnInfo select 0 select 0 isEqualType 0) then 
{
	_spawnInfo = [_spawnInfo];
};

private _buildableConfig = (missionConfigFile >> "gamemode" >> "buildables" >> _buildingType);

if (isNil "_buildingId") then 
{
	// Create building IDs.
	(["GET", "buildables_counter", 0] call para_s_fnc_profile_db) params ["","_buildablesCounter"];
	_buildingId = _buildablesCounter +	1;
	(["SET", "buildables_counter", _buildingId] call para_s_fnc_profile_db);
};

// Load config

//Create an object that represents the building, so we can swap models around at will.
//Give it a position, so we can query on it.
private _buildingPos = _spawnInfo select 0 select 0;
private _building = createSimpleObject ["a3\weapons_f\empty.p3d", AGLToASL _buildingPos];
_building setVariable ["para_s_building_id",_buildingId];
_building setVariable ["para_g_buildclass", _buildingType, true];
_building setVariable ["para_g_build_features", [_buildingType] call para_g_fnc_building_class_get_feature_configs, true];

//Turn the building into a supply source.
private _internalSupplySource = [
	_building,
	getNumber (_buildableConfig >> "supply_capacity"), 
	_initialSupplies
] call para_s_fnc_supply_source_create;

//Keep this here, as although we reference the building now, better to be able to easily change it in the future.
_building setVariable ["para_g_internal_supply_source", _internalSupplySource, true];
//This idea of connecting to a supply source allows multiple objects to share the same supply pool
[_building, _internalSupplySource] call para_s_fnc_building_connect_supply_source;

//Spawn in objects associated with this building.
private _objectClass = getText ([
	_buildableConfig >> "build_states" >> "middle_state" >> "object_class", 
	_buildableConfig >> "build_states" >> "final_state" >> "object_class"
] select (_buildProgress >= 1));

//Start out by spawning in the buildings.
private _objects = _spawnInfo apply 
{
	_x params ["_pos", "_dir"];
	//This position is always going to be a bit inaccurate, as we don't have model's center offset until it's spawned in.
	private _newObject = createVehicle [_objectClass, ASLtoAGL _pos, [], 0, 'CAN_COLLIDE'];
	_newObject setDir _dir;
	//Need to reset position as the spawned-in position will be inaccurate, and is broken by the rotation anyway.
	_newObject setPosWorld _pos;
	_newObject setVariable ["para_g_building", _building, true];

	[[_newObject], "para_c_fnc_buildable_overlay_init", 0, _newObject] call para_s_fnc_remoteExec_jip_obj_stacked;
	
	_newObject
};

//Do *not* call change_objects, as we don't want to fire an event yet.
_building setVariable ["para_g_objects", _objects, true];

//Add build progress to the building, fully building it.
//Do NOT do an object update, as we've instantiated everything correctly above.
[_building, _buildProgress, false] call para_s_fnc_building_add_build_progress;

//Block master arm from using buildings as a supply point.
{
	_x setVariable ["vn_master_arm_supplyAmmo", false, true];
	_x setVariable ["vn_master_arm_supplyFuel", false, true];
	_x setVariable ["vn_master_arm_supplyRepair", false, true];
}forEach _objects;

para_l_buildings pushBack _building;

[_building, "onBuildingPlaced", [_building]] call para_g_fnc_building_fire_feature_event;
[_building, "onBuildingObjectsChanged", [_building, _objects]] call para_g_fnc_building_fire_feature_event;

private _basesContaining = getPos _building call para_g_fnc_bases_containing_pos;

//If a building is inside a FOB displays a feedback message
if !(_basesContaining isEqualTo []) then {
	hint ("This building will be a part of FOB " + str ((_basesContaining # 0) getVariable "para_g_base_name"));
} else {
	//If a building is outside a FOB displays different messages depending on distance
	private _nearbyBases = para_g_bases inAreaArray [getPos _building, para_g_max_base_radius + 200, para_g_max_base_radius + 200];
	if (count _nearbyBases > 0) then {
		private _nearbyBasesPos = _nearbyBases apply {getPos _x};

		private _nearestFobPos = [_nearbyBasesPos, getPos _building] call BIS_fnc_nearestPosition;
		private _nearestFob = _nearbyBases select (_nearbyBasesPos find _nearestFobPos);
		private _nearestFobDist = round (_nearestFob distance2D (getPos _building));
		private _nearestFobDistRadius = round (_nearestFobDist - (_nearestFob getVariable "para_g_base_radius"));
		private _nearestFobDir = round (getPos _building getDir getPos _nearestFob); 
	
		_nearestFobDir = _nearestFobDir % 360;

		hint ("This building will not be a part of a FOB. Move " + str _nearestFobDistRadius + "m heading " + str _nearestFobDir + "º to connect to FOB " + (_nearestFob getVariable "para_g_base_name"));
	
	} else {
		hint "This building will not be part of a FOB";
	};

};

_building