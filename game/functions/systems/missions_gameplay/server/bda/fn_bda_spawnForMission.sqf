/*
	File: fn_bda_spawnForMission.sqf
	Author: Atlas
	Date: 2026-03-05
	Last Update: 2026-03-05
	Public: No

	Description:
		Decision logic for BDA (Battle Damage Assessment) encounter. Rolls
		spawn chance, finds a suitable road position inside the AO, and calls
		the scene builder. BDA sites spawn along roads to simulate bombed
		supply routes.

	Parameter(s):
		_missionId - Id of the mission [NUMBER]
		_roadData  - [roadSegments, intersections] from findRoadPositions [ARRAY]

	Returns:
		Nothing

	Example(s):
		[0, _roadData] call vgm_s_fnc_bda_spawnForMission;
 */

params ["_missionId", "_roadData"];

// Roll spawn chance
if (random 1 > vgm_s_bda_spawnChance) exitWith {
	format ["[BDA] Spawn roll failed for mission %1 (chance: %2)", _missionId, vgm_s_bda_spawnChance] call vgm_g_fnc_logInfo;
};

_roadData params ["_roads", "_intersections"];

if (count _roads < 4) exitWith {
	"[BDA] Not enough roads for BDA site" call vgm_g_fnc_logWarning;
};

private _mission = [_missionId] call vgm_s_fnc_missions_getById;
if (isNil "_mission") exitWith {
	format ["[BDA] Mission does not exist: %1", _missionId] call vgm_g_fnc_logError;
};

private _targetZone = _mission get "public" get "targetZone";
private _sites = +(_targetZone call vgm_s_fnc_missions_zones_getSites);
private _sitePositions = _sites apply {_x get "pos"};

// Build candidate pool: road segments 100m+ from intersections and 150m+ from sites
private _candidates = +_roads;
{
	private _iPos = _x;
	_candidates = _candidates select {getPos _x distance2D _iPos >= 100};
} forEach _intersections;

_candidates = _candidates select {
	private _rPos = getPos _x;
	// 150m from sites, flat terrain, not water
	if (surfaceIsWater _rPos) then {false} else {
		private _normal = surfaceNormal _rPos;
		if ((_normal select 2) < 0.85) then {false} else {
			private _tooClose = false;
			{
				if (_rPos distance2D _x < 150) exitWith {_tooClose = true};
			} forEach _sitePositions;
			!_tooClose
		}
	}
};

if (_candidates isEqualTo []) exitWith {
	"[BDA] No suitable road positions for BDA site" call vgm_g_fnc_logWarning;
};

// Pick a random candidate road position
private _road = selectRandom _candidates;
private _center = getPos _road;
_center set [2, 0];

// Build the scene
[_missionId, _center] call vgm_s_fnc_bda_buildScene;

// Register as a virtual site so photos flow through the scouting pipeline
private _bdaData = vgm_s_bda_missionData get _missionId;
private _spottableObjects = (_bdaData get "sceneObjects") select {
	_x getVariable ["vgm_missions_gameplay_scouting_spottable", false]
};
private _siteId = format ["bda_%1_%2", floor (_center # 0), floor (_center # 1)];
[_missionId, _siteId, _center, "vgm_bda", _spottableObjects] call vgm_s_fnc_missions_gameplay_scouting_registerVirtualSite;

format ["[BDA] Spawned BDA site at %1 for mission %2", _center, _missionId] call vgm_g_fnc_logInfo;
