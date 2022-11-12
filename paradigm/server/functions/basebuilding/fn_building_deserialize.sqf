/*
    File: fn_building_deserialize.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
		Instantiates a building from its serialized representation (loads it)
    
    Parameter(s):
        _serializedBuilding - A building in its serialized form [ARRAY]
    
    Returns:
		Building created [NAMESPACE]
    
    Example(s):
		[_save] call para_s_fnc_building_deserialize
*/

params ["_serializedBuilding"];

private _version = _serializedBuilding select 0;
if (_version == "1.0") exitWith 
{
	_serializedBuilding params 
	[
		"_version",
		"_id",
		"_type",
		"_internalSupplies",
		"_serializedSpawnInfo",
		"_buildProgress"
	];

	private _spawnInfo = _serializedSpawnInfo apply {[_x # 0 apply {parseNumber _x}, parseNumber (_x # 1)]};

	[_type, _spawnInfo, _buildProgress, _internalSupplies, _id] call para_s_fnc_building_create
};