/*
    File: fn_objGrabber_eden_grab.sqf
    Author: Joris-Jan van 't Land and Savage Game Design
    Date: 2024-08-02
    Last Update: 2024-08-10
    Public: Yes

    Description:
        Converts a set of placed objects to an object array for the VGM version of the DynO mapper.

    Parameter(s):
        _grabOrientation - Whether to grab pitch/bank of the object [BOOLEAN]
        _alignToSurfaceNormal - Whether objects should be aligned to the surface normal when placed [BOOLEAN]
        _useTerrainHeight - Whether objects should spawn using their current height above their terrain, instead of absolute offset from other objects [BOOLEAN]

    Returns:
        Composition details [HashMap]

    Example(s):
        [true, true, false] call vgm_g_fnc_sites_objectGrabber
 */


params [
    ["_grabOrientation", true],
    ["_alignToSurfaceNormal", false],
    ["_useTerrainHeight", false]
];

private _fnc_getObjectsCenter = {
	params ["_objs"];
	private _center = [0, 0, 0];

	{
		_center = _center vectorAdd getPosWorld _x;
	} forEach _objs;

	private _averageMultiplier = 1 / (count _objs);
	_center = _center vectorMultiply _averageMultiplier;

	ATLtoASL [_center # 0, _center # 1, 0]
};

private _objs = get3DENSelected "object" select {!(_x isKindOf "Man")};
private _centerASL = [_objs] call _fnc_getObjectsCenter;
private _objectDetails = [];

private _objectDetails = _objs apply {
	private _type = typeOf _x;
    private _posWorld = getPosWorld _x;
    private _posATL = ASLtoATL _posWorld;
	private _vectorDiff = _posWorld vectorDiff _centerASL;
	private _dX = _vectorDiff # 0;
	private _dY = _vectorDiff # 1;
    // Z relative to the composition center point.
	private _relativeZ = _vectorDiff # 2;
    // Z of this object relative to the terrain at its position (i.e - height above terrain)
    private _terrainZ = _posATL # 2;
	private _vectorDir = vectorDir _x;
	private _vectorUp = vectorUp _x;
	private _fuel = fuel _x;
	private _damage = damage _x;
	private _init = _x get3DENAttribute "Init" select 0;
	private _simulation = _x get3DENAttribute "enableSimulation" select 0;
	private _allowDamage = _x get3DENAttribute "allowDamage" select 0;
    // Mapper will set this so it persists across placed objects if manually edited later.
    private _useObjectTerrainHeight = _x getVariable ["useTerrainHeight", _useTerrainHeight];

	[_type, [_dX, _dY], _relativeZ, _terrainZ, _vectorDir, _vectorUp, _fuel, _damage, _init, _simulation, _allowDamage, _useObjectTerrainHeight];
};

// Sort objects by disabled simulation, then by height, so any objects resting on other objects don't fall through when spawning.
private _sortedByHeight = [];
{
    _sortedByHeight pushBack [!(_x # 9), _x # 2, _forEachIndex];
} forEach _objectDetails;
_sortedByHeight sort true;

private _objectDetails = _sortedByHeight apply {_objectDetails # (_x # 2)};

private _output = _objectDetails;

copyToClipboard str _output;

_output
