/*
    File: fn_amblife_spawnWireTaps.sqf
    Author: AtlasActual
    Date: 2026-03-05
    Last Update: 2026-03-05
    Public: No

    Description:
        Spawns NVA field telephone wire tap junction boxes along road segments.
        Each wire tap consists of two small wooden posts 4-6m apart along the
        road edge, with a junction box (interaction target) placed between them.
        Prefers road segments away from intersections and near tree cover.

    Parameter(s):
        _missionId - Mission ID [NUMBER]
        _roadData  - [roadSegments, intersections] from findRoadPositions [ARRAY]
        _count     - Number of wire taps to spawn [NUMBER]

    Returns:
        Nothing

    Example(s):
        [0, _roadData, 2] call vgm_s_fnc_amblife_spawnWireTaps;
 */

params ["_missionId", "_roadData", "_count"];

_roadData params ["_roads", "_intersections"];

if (_count <= 0 || count _roads < 4) exitWith {};

private _objects = vgm_s_amblife_missionObjects get _missionId;

// Build candidate pool: road segments 100m+ from intersections
private _candidates = +_roads;
{
	private _iPos = _x;
	_candidates = _candidates select {getPos _x distance2D _iPos >= 100};
} forEach _intersections;

// Prefer candidates near tree cover (within 30m)
private _preferred = _candidates select {
	count (nearestTerrainObjects [getPos _x, ["TREE", "BUSH"], 30, false]) > 0
};

// Use preferred if we have enough, otherwise fall back to all candidates
private _pool = if (count _preferred >= _count) then {_preferred} else {_candidates};

// Select positions with 200m minimum spacing
private _chosen = [];
for "_i" from 1 to _count do {
	if (count _pool == 0) exitWith {};
	private _road = selectRandom _pool;
	private _pos = getPos _road;
	_chosen pushBack [_road, _pos];
	_pool = _pool select {getPos _x distance2D _pos >= 200};
};

// Spawn wire tap props at each chosen position
{
	_x params ["_road", "_pos"];

	// Determine road direction
	private _roadDir = 0;
	if (!isNull _road) then {
		private _conn = roadsConnectedTo _road;
		if (count _conn > 0) then {
			_roadDir = _road getDir (_conn # 0);
		};
	};

	// Perpendicular offset direction (right side of road)
	private _perpDir = _roadDir + 90;

	// Base position offset 2-3m from road center
	private _offsetDist = 2 + random 1;
	private _basePos = _pos vectorAdd [_offsetDist * sin _perpDir, _offsetDist * cos _perpDir, 0];

	// Place two fence/wire posts 4-6m apart along road direction
	private _postSpacing = (4 + random 2) / 2;
	{
		private _offset = [1, -1] # _forEachIndex;
		private _postPos = _basePos vectorAdd [_offset * _postSpacing * sin _roadDir, _offset * _postSpacing * cos _roadDir, 0];
		private _postPosATL = [_postPos # 0, _postPos # 1, 0];
		private _post = createSimpleObject ["vn_fence_punji_01_10_part1", ATLToASL _postPosATL, true];
		_post setDir (_roadDir + (random 10) - 5);
		_post enableSimulationGlobal false;
		_objects pushBack _post;
	} forEach [0, 1];

	// Place junction box (interaction target) — must be a real object for hold actions
	private _wirePos = [_basePos # 0, _basePos # 1, 0];
	private _junctionBox = createVehicle ["vn_o_ammobox_03", _wirePos, [], 0, "CAN_COLLIDE"];
	_junctionBox setDir (_roadDir + random 20 - 10);
	_junctionBox enableSimulationGlobal false;
	_junctionBox allowDamage false;
	_junctionBox setVariable ["vgm_wireTap_active", true, true];
	_junctionBox setVariable ["vgm_wireTap_missionId", _missionId, true];
	_objects pushBack _junctionBox;

	// Register junction box with glint/hints system for Focus Mode
	[_junctionBox, [_wirePos]] remoteExec ["vgm_c_fnc_sites_hints_initObject", 0, true];

	format ["[AmbLife] Wire tap spawned at %1 for mission %2", _wirePos, _missionId] call vgm_g_fnc_logInfo;
} forEach _chosen;
