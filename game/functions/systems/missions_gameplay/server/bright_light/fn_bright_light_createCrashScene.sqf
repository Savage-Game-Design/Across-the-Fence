/*
    File: fn_bright_light_createCrashScene.sqf
    Author: Atlas
    Date: 2026-03-05
    Last Update: 2026-03-05
    Public: No

    Description:
        Creates an immersive helicopter crash scene at the given position.
        Clears terrain, spawns crater, wreck, smoke column, fires, and dead crew.
        Used by both the Bright Light mission system and the CAS shootdown system.

    Parameter(s):
        _crashPos   - Position ATL for the crash scene [ARRAY]
        _crashDir   - Direction for the wreck (degrees) [NUMBER, default random]
        _wreckClass - Classname of wreck to spawn [STRING, default "" for random UH-1D/OH-6A]
        _crewClass  - Classname for dead crew bodies [STRING, default "vn_b_men_aircrew_01"]
        _crewCount  - Number of dead crew bodies [NUMBER, default 3]

    Returns:
        HashMap with keys:
            "sceneObjects"          - All created objects [ARRAY]
            "hiddenTerrainObjects"  - Terrain objects hidden [ARRAY]
            "wreck"                 - The wreck object [OBJECT]

    Example(s):
        [_crashPos, random 360] call vgm_s_fnc_bright_light_createCrashScene
        [_crashPos, 180, "vn_air_ah1g_01_wreck", "vn_b_men_aircrew_01", 2] call vgm_s_fnc_bright_light_createCrashScene
*/

params ["_crashPos", ["_crashDir", random 360], ["_wreckClass", ""], ["_crewClass", "vn_b_men_aircrew_01"], ["_crewCount", 3]];

if (!isServer) exitWith {createHashMap};

private _sceneObjects = [];
private _hiddenTerrainObjects = [];

// Clear terrain objects in 20m radius
private _terrainObjs = nearestTerrainObjects [_crashPos, [], 20, false];
{
    _x hideObjectGlobal true;
    _hiddenTerrainObjects pushBack _x;
} forEach _terrainObjs;

// Clear grass/clutter around crash site
for "_i" from 1 to 5 do {
    private _cutterPos = _crashPos getPos [random 8, _i * 72];
    private _cutter = createVehicle ["Land_ClutterCutter_large_F", _cutterPos, [], 0, "CAN_COLLIDE"];
    _sceneObjects pushBack _cutter;
};

// Crater underneath wreck
private _crater = createVehicle ["CraterLong", _crashPos, [], 0, "CAN_COLLIDE"];
_crater setDir random 360;
_sceneObjects pushBack _crater;

// Wreck: use provided class or random default
if (_wreckClass == "") then {
    _wreckClass = selectRandom ["vn_air_uh1d_01_wreck", "vn_air_oh6a_01_wreck"];
};
private _wreck = createVehicle [_wreckClass, _crashPos, [], 0, "CAN_COLLIDE"];
_wreck setDir _crashDir;
_wreck setVectorUp [0.2 - random 0.4, 0.2 - random 0.4, 0.85];
_wreck enableSimulationGlobal false;
_sceneObjects pushBack _wreck;

// Smoke column
private _smokePos = +_crashPos;
_smokePos set [2, 1];
private _smoke = "#particlesource" createVehicle _smokePos;
_smoke setParticleParams [
    ["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 12, 8, 0],
    "", "Billboard", 1, 10, [0,0,0], [0,0,3], 1, 1.2, 0.9, 0.4,
    [4, 8, 15], [[0.1,0.1,0.1,0.6],[0.15,0.15,0.15,0.4],[0.2,0.2,0.2,0.1]],
    [0.5], 1, 0, "", "", _smoke
];
_smoke setParticleRandom [3, [1,1,0], [0.5,0.5,0.5], 0, 0.5, [0,0,0,0.1], 0, 0, 0];
_smoke setDropInterval 0.08;
_sceneObjects pushBack _smoke;

// Fires around wreck (2-3)
private _fireCount = 2 + floor random 2;
for "_i" from 1 to _fireCount do {
    private _firePos = _crashPos getPos [2 + random 5, random 360];
    private _fire = createVehicle ["test_EmptyObjectForFireBig", _firePos, [], 0, "CAN_COLLIDE"];
    _sceneObjects pushBack _fire;
};

// Dead crew bodies near wreck
private _deadGrp = createGroup west;
_deadGrp deleteGroupWhenEmpty true;
for "_i" from 1 to _crewCount do {
    private _deadUnit = _deadGrp createUnit [_crewClass, _crashPos getPos [2 + random 5, random 360], [], 0, "NONE"];
    _deadUnit setDamage 1;
    _sceneObjects pushBack _deadUnit;
};

private _result = createHashMapFromArray [
    ["sceneObjects", _sceneObjects],
    ["hiddenTerrainObjects", _hiddenTerrainObjects],
    ["wreck", _wreck]
];

format ["Bright Light: Crash scene created at %1 (%2 objects, %3 terrain hidden)", _crashPos, count _sceneObjects, count _hiddenTerrainObjects] call vgm_g_fnc_logInfo;

_result
