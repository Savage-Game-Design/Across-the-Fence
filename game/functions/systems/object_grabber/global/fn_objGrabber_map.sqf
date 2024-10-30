/*
	File: fn_objGrabber_map.sqf
	Author: Joris-Jan van't Land and Savage Game Design
	Date: 2024-08-10
	Last Update: 2024-08-10
	Public: Yes

	Description:
		Takes an array of data about a dynamic object template and creates the objects.

	Parameter(s):
		_pos - Position of the template in AGL/ATL [ARRAY]
		_azi - Rotation to apply to the template in degrees (clockwise) [NUMBER]
		_objs - Array of objects produced by vgm_g_fnc_objGrabber_eden_grab [ARRAY]
        _options - Additional options (VEGETATION_FRACTION)[HASHMAP]

	Returns:
		Spawned objects [ARRAY]

	Example(s):
		[[0, 0, 0], 0, []] call vgm_g_fnc_sites_objectsMapper;
 */

params ["_pos", ["_azi", 0], ["_objs", []], ["_options", []]];

private _parsedOptions = createHashMapFromArray _options;
// How much the vegetation should randomly be reduced by
private _vegetationFraction = _parsedOptions getOrDefault ["VEGETATION_FRACTION", 1];

_pos params ["_posX", "_posY"];
private _posASL = AGLtoASL _pos;
private _newObjs = [];

{
	_x params [
		"_type",
		"_pos2D",
		"_relativeZ",
		"_terrainZ",
		"_vectorDir",
		"_vectorUp",
		"_fuel",
		"_damage",
		"_initCode",
		"_simulation",
        "_allowDamage",
		"_useObjectTerrainHeight"
	];

    if (_type isKindOf "Land_vn_vegetation_base" && random 1 > _vegetationFraction) then {
        continue
    };


	//Rotate the relative position using a rotation matrix
	private _rotMatrix =
	[
		[cos -_azi, sin -_azi],
		[-(sin -_azi), cos -_azi]
	];
	private _newRelPos = ([_pos2D] matrixMultiply _rotMatrix) # 0;
	private _newPos = [];
	private _newPosASL = [];

	if (_useObjectTerrainHeight) then {
		_newPos = _newRelPos vectorAdd _pos vectorAdd [0, 0, _terrainZ];
		_newPosASL = AGLtoASL _newPos;
	} else {
		_newPosASL = _newRelPos vectorAdd _posASL vectorAdd [0, 0, _relativeZ];
		_newPos = ASLtoAGL _newPosASL;
	};

	private _newVectorDir = [_vectorDir, _azi, 2] call BIS_fnc_rotateVector3D;
	private _newVectorUp = [_vectorUp, _azi, 2] call BIS_fnc_rotateVector3D;

	//Create the object and make sure it's in the correct location
	private _newObj = createVehicle [_type, _newPos, [], 0, "CAN_COLLIDE"];
	_newObj setVectorDirAndUp [_newVectorDir, _newVectorUp];
	_newObj setPosWorld _newPosASL;


    // Set this so that if it gets re-grabbed, the setting persists. Useful if a particular object was manually altered.
	_newObj setVariable ["useTerrainHeight", _useObjectTerrainHeight];

	//If fuel and damage were grabbed, map them
	if (!isNil "_fuel") then {_newObj setFuel _fuel};
	if (!isNil "_damage") then {_newObj setDamage _damage;};
	if (!isNil "_init") then {_newObj call (compile ("this = _this; " + _initCode));};
	if (!isNil "_simulation") then {_newObj enableSimulationGlobal _simulation};
	if (!isNil "_allowDamage") then {_newObj allowDamage _allowDamage};

	_newObjs pushBack _newObj;
} forEach _objs;

_newObjs
