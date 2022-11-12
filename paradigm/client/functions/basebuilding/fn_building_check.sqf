/*
    File: fn_building_check.sqf
    Author:  Savage Game Design
    Public: No

    Description:
	No description added yet.

    Parameter(s):
	_object - Description [DATATYPE, defaults to DEFAULTVALUE]
	_neededNearby - Description [DATATYPE, defaults to DEFAULTVALUE]

    Returns:
	Function reached the end [BOOL]

    Example(s):
	[parameter] call para_c_fnc_building_check
*/

params ["_args", "_eventArgs"];

_args params ["_buildingConfig"];
_eventArgs params ["_object","_neededNearby",["_startPos",[0,0,0]],["_stopPos",[0,0,-1]]];

private _transparent = "#(rgb,8,8,3)color(1,1,1,0)";	// transparent texture
private _whitetexture = "#(rgb,8,8,3)color(1,1,1,0.7)";	// white texture
private _bluetexture = "#(rgb,8,8,3)color(0,0,1,0.7)"; 	// blue texture
private _greentexture = "#(rgb,8,8,3)color(0,1,0,0.7)"; // green texture
private _redtexture = "#(rgb,8,8,3)color(1,0,0,0.7)"; 	// red texture

private _placingAllowed = true;
private _texture = _greentexture; // green texture
private _errorMessage = "";

if (vn_mf_markers_blocked_areas findIf {_object inArea _x} > -1) then
{
	_placingAllowed = false;
	_errorMessage = localize "STR_vn_mf_restrictedzone";
	_texture = _redtexture;  // red texture
};

if (_placingAllowed && para_l_buildables_require_vehicles && !(_neededNearby isEqualTo [])) then
{
	private _nearbyVehicles = (getPos _object) nearObjects ["LandVehicle", 20];
	if ("fuel" in _neededNearby && {_nearbyVehicles findIf {getFuelCargo _x > 0} isEqualTo -1}) exitWith
	{
		_placingAllowed = false;
		_errorMessage = "A fuel truck must be nearby to build this building.";
		_texture = _redtexture;
	};
	if ("ammo" in _neededNearby && {_nearbyVehicles findIf {getAmmoCargo _x > 0} isEqualTo -1}) exitWith
	{
		_placingAllowed = false;
		_errorMessage = "An ammo truck must be nearby to build this building.";
		_texture = _redtexture;
	};
	if ("repair" in _neededNearby && {(_nearbyVehicles select {getRepairCargo _x > 0} isEqualTo [])}) exitWith
	{
		_placingAllowed = false;
		_errorMessage = "A repair truck must be nearby to build this building.";
		_texture = _redtexture;
	};
};

if (_placingAllowed) then {
	private _bb = boundingBoxReal _object;
	private _center = [(_bb # 0 # 0 + _bb # 1 # 0) / 2, (_bb # 0 # 1 + _bb # 1 # 1) / 2];
	private _model_center_bottom = _center + [_bb # 0 # 2];
	private _startPos = _object modelToWorld (_model_center_bottom);
	private _stopPos = _startPos vectoradd [0,0,-0.1];

	// this maybe clostly
	private _ins = lineIntersectsSurfaces [
		AGLToASL _startPos,
		AGLToASL _stopPos,
		_object
	];
	if (getPosATL _object select 2 > 0 && count _ins == 0) exitWith {
		_placingAllowed = false;
		_errorMessage = "The building cannot be floating.";
		_texture = _redtexture;
	};
	if (count _ins > 0 && {(_ins select 0) select 2 isKindOf "AllVehicles"}) exitWith {
		_placingAllowed = false;
		_errorMessage = "The building cannot be built on a vehicle.";
		_texture = _redtexture;
	};
};

if (_placingAllowed && !isNil "_buildingConfig") then {
	private _results = 
		[configName _buildingConfig, "canPlaceBuilding", [_buildingConfig, _object]] call para_g_fnc_building_class_fire_feature_event;
	private _firstUnplacableFeatureIndex = _results findIf {!(_x # 0)};

	if (_firstUnplacableFeatureIndex == -1) exitWith {};

	_placingAllowed = false;
	_errorMessage = _results # _firstUnplacableFeatureIndex # 1;
	_texture = _redtexture;
};

if (!_placingAllowed) then {
	// use color from attached object
	// Guessing this is something to do with bridge building
	private _attached_to = attachedTo _object;
	if (!isNull _attached_to && !(_attached_to isEqualto player)) then {
		_texture = (getObjectTextures _attached_to) select 0;
	};
};

// only set texture when changed
private _textures = getObjectTextures _object;
if !(_texture in _textures) then
{
	_object setObjectTextureGlobal [0, _texture];
};

[_placingAllowed, _errorMessage]
