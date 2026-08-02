/*
	File: fn_bda_buildScene.sqf
	Author: Atlas
	Date: 2026-03-05
	Last Update: 2026-03-05
	Public: No

	Description:
		Constructs the BDA (Battle Damage Assessment) scene: clears terrain,
		places craters, destroyed trucks with optional smoke, scattered dead
		NVA, real mines, and a small live NVA patrol nearby. Trucks are
		searchable for XP. Key objects are registered with the hints/glint
		system and marked as photographable.

	Parameter(s):
		_missionId - Id of the mission [NUMBER]
		_center    - Center position of the BDA field [ARRAY]

	Returns:
		Nothing

	Example(s):
		[0, [1000, 2000, 0]] call vgm_s_fnc_bda_buildScene;
 */

params ["_missionId", "_center"];

private _sceneObjects = [];
private _hiddenTerrainObjects = [];
private _groups = [];

// --- 1. Clear terrain objects in 25m radius ---
private _terrainObjs = nearestTerrainObjects [_center, [], 25, false];
{
	_x hideObjectGlobal true;
	_hiddenTerrainObjects pushBack _x;
} forEach _terrainObjs;

// --- 2. Clear ground clutter ---
for "_i" from 1 to 7 do {
	private _cutterPos = _center getPos [random 15, _i * (360 / 7)];
	private _cutter = createVehicle ["Land_ClutterCutter_large_F", _cutterPos, [], 0, "CAN_COLLIDE"];
	_sceneObjects pushBack _cutter;
};

// --- 3. Place bomb craters ---
private _craterCount = 4 + floor random 3;
for "_i" from 1 to _craterCount do {
	private _craterPos = _center getPos [5 + random 25, random 360];
	private _crater = createVehicle [selectRandom vgm_s_bda_craterClasses, _craterPos, [], 0, "CAN_COLLIDE"];
	_crater setDir random 360;
	_sceneObjects pushBack _crater;

	// Register with hints/glint system (visual discovery aid — not counted for photo quality)
	[_crater, [_center]] remoteExec ["vgm_c_fnc_sites_hints_initObject", 0, true];
};

// --- 4. Spawn destroyed trucks with optional smoke ---
private _truckCount = 1 + floor random 2;
private _trucks = [];
for "_i" from 1 to _truckCount do {
	// Find a safe position: no water, gentle slope, no rock/building collisions
	private _truckPos = [];
	private _attempts = 0;
	while {_attempts < 15} do {
		private _candidate = _center getPos [8 + random 15, random 360];
		_attempts = _attempts + 1;

		// Skip water
		if (surfaceIsWater _candidate) then {continue};

		// Skip steep terrain (> ~20 degrees)
		private _normal = surfaceNormal _candidate;
		if ((_normal select 2) < 0.94) then {continue};

		// Skip if rocks or buildings within 5m
		private _blocking = nearestTerrainObjects [_candidate, ["ROCK", "BUILDING", "WALL"], 5, false];
		if (_blocking isNotEqualTo []) then {continue};

		// Skip if too close to an already-placed truck
		private _tooClose = false;
		{if (_candidate distance2D (getPosATL _x) < 8) exitWith {_tooClose = true}} forEach _trucks;
		if (_tooClose) then {continue};

		_truckPos = _candidate;
		_attempts = 99;
	};

	// If no valid position found, skip this truck
	if (_truckPos isEqualTo []) then {
		format ["[BDA] Could not find safe truck position near %1, skipping", _center] call vgm_g_fnc_logWarning;
		continue;
	};

	private _truck = createVehicle [selectRandom vgm_s_bda_truckClasses, _truckPos, [], 0, "CAN_COLLIDE"];

	// Verify vehicle was created
	if (isNull _truck) then {
		format ["[BDA] Failed to create truck at %1", _truckPos] call vgm_g_fnc_logWarning;
		continue;
	};

	_truck setDamage (0.7 + random 0.3);
	_truck setDir random 360;
	_truck setVectorUp [0.1 - random 0.2, 0.1 - random 0.2, 0.9];
	_sceneObjects pushBack _truck;
	_trucks pushBack _truck;

	// Mark as photographable
	_truck setVariable ["vgm_missions_gameplay_scouting_spottable", true, true];

	// Register with hints/glint system
	[_truck, [_center]] remoteExec ["vgm_c_fnc_sites_hints_initObject", 0, true];

	// 60% chance of black smoke column (NO fire)
	if (random 1 < 0.6) then {
		private _smokePos = +_truckPos;
		_smokePos set [2, 1];
		private _smoke = "#particlesource" createVehicle _smokePos;
		_smoke setParticleParams [
			["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 12, 8, 0],
			"", "Billboard", 1, 14, [0,0,0], [0,0,5], 1, 1.4, 0.9, 0.3,
			[3, 8, 20], [[0,0,0,0.8],[0.02,0.02,0.02,0.6],[0.05,0.05,0.05,0.15]],
			[0.5], 1, 0, "", "", _smoke
		];
		_smoke setParticleRandom [2, [0.5,0.5,0], [0.3,0.3,0.3], 0, 0.3, [0,0,0,0.05], 0, 0, 0];
		_smoke setDropInterval 0.05;
		_sceneObjects pushBack _smoke;
	};

	// Hold action: search wreckage for XP
	_truck setVariable ["vgm_bda_missionId", _missionId, true];
	_truck setVariable ["vgm_bda_searched", false, true];

	[
		_truck,
		format ["<t color='#ed872d'>%1</t>", "Search Wreckage"],
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",
		"_this distance _target < 4 && !(_target getVariable ['vgm_bda_searched', false])",
		"_caller distance _target < 4",
		{},
		{},
		{
			params ["_target", "_caller", "_actionId"];
			_target setVariable ["vgm_bda_searched", true, true];
			[_target, _actionId] remoteExec ["BIS_fnc_holdActionRemove", 0, _target];
			[_caller, 25] remoteExecCall ["vgm_s_fnc_leveling_addExperience", 2];
			hint parseText "<t size='1.2' color='#82E0AA'>Wreckage Searched</t><br/>+25 XP";
		},
		{},
		nil,
		10,
		100,
		true,
		false
	] remoteExec ["BIS_fnc_holdActionAdd", 0, _truck];
};

// --- 5. Scatter dead NVA bodies ---
private _deadCount = 3 + floor random 3;
private _deadGrp = createGroup east;
_deadGrp deleteGroupWhenEmpty true;
_groups pushBack _deadGrp;
for "_i" from 1 to _deadCount do {
	private _deadPos = _center getPos [3 + random 20, random 360];
	private _deadUnit = _deadGrp createUnit [selectRandom vgm_s_bda_nvaClasses, _deadPos, [], 0, "NONE"];
	_deadUnit setDamage 1;
	_sceneObjects pushBack _deadUnit;
};

// --- 6. Place mines ---
private _mineCount = 4 + floor random 5;
for "_i" from 1 to _mineCount do {
	private _minePos = _center getPos [5 + random 30, random 360];
	private _mine = createMine [vgm_s_bda_mineClass, _minePos, [], 0];
	east revealMine _mine;
	civilian revealMine _mine;
	_sceneObjects pushBack _mine;
};

// --- 7. Spawn live NVA patrol nearby ---
private _patrolCount = 2 + floor random 2;
private _patrolGrp = createGroup east;
_patrolGrp deleteGroupWhenEmpty true;
_groups pushBack _patrolGrp;

private _patrolPos = _center getPos [100 + random 50, random 360];
for "_i" from 1 to _patrolCount do {
	private _unit = _patrolGrp createUnit [selectRandom vgm_s_bda_nvaClasses, _patrolPos, [], 5, "NONE"];
	_sceneObjects pushBack _unit;
};

_patrolGrp setBehaviourStrong "AWARE";
_patrolGrp setCombatMode "RED";
private _wp = _patrolGrp addWaypoint [_center, 30];
_wp setWaypointType "GUARD";

// --- 8. Store all data for cleanup ---
private _data = createHashMapFromArray [
	["sceneObjects", _sceneObjects],
	["hiddenTerrain", _hiddenTerrainObjects],
	["groups", _groups],
	["center", _center],
	["trucks", _trucks]
];
vgm_s_bda_missionData set [_missionId, _data];
