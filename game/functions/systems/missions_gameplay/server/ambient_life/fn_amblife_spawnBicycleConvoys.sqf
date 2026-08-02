/*
    File: fn_amblife_spawnBicycleConvoys.sqf
    Author: AtlasActual
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Spawns PAVN bicycle supply columns on roads. Each convoy is a
        multi-bike virtsquad (2-4 cargo bikes) with no behaviour tree.
        Uses COLUMN formation, forceFollowRoad, and CYCLE waypoints
        for continuous looping. Slower than trucks (limitSpeed 20) to
        represent heavy supply loads.

    Parameter(s):
        _missionId - Mission ID [NUMBER]
        _roadData  - [roadSegments, intersections] from findRoadPositions [ARRAY]
        _count     - Number of bicycle convoys to spawn [NUMBER]

    Returns:
        Nothing

    Example(s):
        [0, _roadData, 2] call vgm_s_fnc_amblife_spawnBicycleConvoys;
 */

params ["_missionId", "_roadData", "_count"];

if (_count <= 0) exitWith {};

_roadData params ["_roads", "_intersections"];

if (count _roads < 4) exitWith {};

// Helper: pick N spread-out road positions
private _fnc_pickRoadPositions = {
    params ["_count", "_minDist"];
    private _picked = [];
    private _available = +_roads;
    for "_i" from 1 to _count do {
        if (count _available == 0) exitWith {};
        private _road = selectRandom _available;
        private _pos = getPos _road;
        _picked pushBack _pos;
        _available = _available select {getPos _x distance2D _pos >= _minDist};
    };
    _picked
};

private _spawnPositions = [_count, 250] call _fnc_pickRoadPositions;

{
    private _convoyPos = _x;

    // Determine convoy size from config range
    private _min = vgm_s_amblife_bikeConvoySizeRange # 0;
    private _max = vgm_s_amblife_bikeConvoySizeRange # 1;
    private _convoySize = _min + floor random ((_max - _min) + 1);

    // Build composition: one rifleman per bike
    private _composition = [];
    for "_i" from 1 to _convoySize do {
        _composition pushBack (selectRandom vgm_s_amblife_bikeMuleClasses);
    };

    private _template = [
        _composition,
        _convoyPos,
        _missionId
    ] call vgm_s_fnc_director_getEnemySquadTemplate;

    // Remove btree so Arma's native AI handles cycling
    _template deleteAt "btreeName";
    _template set ["deleteOnDespawn", true];
    _template set ["sizeRange", [_convoySize, _convoySize]];
    _template set ["amblife_type", "bicycleConvoy"];
    _template set ["amblife_convoySize", _convoySize];
    _template set ["onSpawn", {
        params ["_squad"];
        private _group = _squad get "group";
        private _units = units _group;
        private _pos = getPos (leader _group);
        private _vehicles = [];

        // Create a cargo bicycle for each unit
        {
            private _offset = _pos getPos [_forEachIndex * 8, 180]; // stagger behind leader
            private _safePos = _offset findEmptyPosition [0, 15, "vn_o_bicycle_02"];
            if (_safePos isEqualTo []) then {
                _safePos = _offset findEmptyPosition [3, 30, "vn_o_bicycle_02"];
            };
            if (_safePos isEqualTo []) then {
                diag_log format ["[AmbLife] No safe position for convoy bike %1 at %2 - skipping", _forEachIndex, _offset];
            } else {
                private _bike = createVehicle ["vn_o_bicycle_02", _safePos, [], 0, "NONE"];
                _x moveInDriver _bike;
                _bike forceFollowRoad true;
                _bike setVariable ["vgm_missions_gameplay_scouting_spottable", true, true];
                _bike addEventHandler ["Killed", {
                    params ["_vehicle", "_killer", "_instigator"];
                    private _player = if (!isNull _instigator) then {_instigator} else {_killer};
                    if (isNull _player || {!isPlayer _player}) exitWith {};
                    [_player, 25] call vgm_s_fnc_leveling_addExperience;
                    {hint parseText "<t size='1.1' color='#FFD700'>+25 XP</t><br/><t size='0.85'>Supply bike destroyed</t>"} remoteExec ["call", _player];
                }];
                vgm_s_amblife_activeBikes pushBack _bike;
                _vehicles pushBack _bike;
            };
        } forEach _units;

        _squad set ["amblife_vehicles", _vehicles];

        // Set convoy formation and behaviour
        _group setFormation "COLUMN";
        _group setBehaviourStrong "SAFE";
        _group setCombatMode "YELLOW";
        _group setSpeedMode "FULL";

        // Walk road network for destination
        private _destPos = [_pos, 600, 1000] call vgm_s_fnc_amblife_walkRoadNetwork;

        if !(_destPos isEqualTo []) then {
            private _wp = _group addWaypoint [_destPos, 10];
            _wp setWaypointType "MOVE";
            _wp setWaypointSpeed "FULL";
            _wp setWaypointCompletionRadius 20;

            // Cycle back to start for looping
            private _wpCycle = _group addWaypoint [_pos, 10];
            _wpCycle setWaypointType "CYCLE";
        };

        diag_log format ["[AmbLife] Spawned bicycle convoy (%1 bikes) at %2", count _vehicles, _pos];
    }];

    [_template] call vgm_s_fnc_virtsquad_create;
} forEach _spawnPositions;
