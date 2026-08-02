/*
    File: fn_ron_spawnProbe.sqf
    Author: Atlas
    Date: 2026-03-06
    Last Update: 2026-03-06
    Public: No

    Description:
        Spawns 5-9 NVA soldiers in a stealth ring around a group's position.
        Units creep inward toward the players. Called once per active group
        during a RON contact outcome.

    Parameter(s):
        _players - Array of player units in the group [ARRAY]

    Returns:
        Nothing

    Example(s):
        [_players] call vgm_s_fnc_ron_spawnProbe;
 */

params ["_players"];

if (!isServer) exitWith {};

private _alivePlayers = _players select {alive _x};
if (_alivePlayers isEqualTo []) exitWith {};

// Compute group centroid
private _centroid = [0, 0, 0];
{
    private _pos = getPosATL _x;
    _centroid set [0, (_centroid select 0) + (_pos select 0)];
    _centroid set [1, (_centroid select 1) + (_pos select 1)];
} forEach _alivePlayers;

private _count = count _alivePlayers;
_centroid set [0, (_centroid select 0) / _count];
_centroid set [1, (_centroid select 1) / _count];
_centroid set [2, 0];

// NVA infantry classes
private _enemyClasses = [
    "vn_o_men_nva_02",
    "vn_o_men_nva_03",
    "vn_o_men_nva_04",
    "vn_o_men_nva_05",
    "vn_o_men_nva_06",
    "vn_o_men_nva_07"
];

// Spawn 5-9 NVA
private _spawnCount = 5 + floor random 5;
private _group = createGroup east;
_group deleteGroupWhenEmpty true;

private _spawnedUnits = [];
private _angleStep = 360 / _spawnCount;

for "_i" from 0 to (_spawnCount - 1) do {
    private _angle = _angleStep * _i + (random 20 - 10);
    private _dist = 30 + random 20;
    private _spawnPos = _centroid getPos [_dist, _angle];

    // Ensure position is on land
    if (surfaceIsWater _spawnPos) then { continue };

    private _unit = _group createUnit [selectRandom _enemyClasses, _spawnPos, [], 0, "NONE"];
    _unit setPosATL _spawnPos;

    // Face toward players
    _unit setDir (_spawnPos getDir _centroid);

    // Stealth configuration
    _unit setUnitTrait ["camouflageCoef", 0.3];
    _unit setUnitPos "MIDDLE";

    _spawnedUnits pushBack _unit;
};

if (_spawnedUnits isEqualTo []) exitWith {
    deleteGroup _group;
    "RON Probe: No units spawned (all positions were water)" call vgm_g_fnc_logInfo;
};

// Group behavior — creep in silently
_group setBehaviourStrong "STEALTH";
_group setCombatMode "YELLOW";
_group setSpeedMode "LIMITED";

// SAD waypoint on player centroid
private _wp = _group addWaypoint [_centroid, 15];
_wp setWaypointType "SAD";

format ["RON Probe: Spawned %1 NVA at %2 (%3m ring around %4 players)",
    count _spawnedUnits, _centroid, "30-50", _count] call vgm_g_fnc_logInfo;
