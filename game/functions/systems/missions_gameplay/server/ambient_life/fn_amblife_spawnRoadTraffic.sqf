/*
    File: fn_amblife_spawnRoadTraffic.sqf
    Author: AtlasActual
    Date: 2026-03-03
    Last Update: 2026-03-04
    Public: No

    Description:
        Spawns OPFOR supply truck convoys and civilian road vehicles on roads.
        Trucks spawn in convoys (2-3 per convoy) as multi-vehicle virtsquads
        with no behaviour tree, using Arma's native AI for road-following.
        COLUMN formation, forceFollowRoad, and CYCLE waypoints keep convoys
        looping on roads.

    Parameter(s):
        _missionId       - Mission ID [NUMBER]
        _roadData        - [roadSegments, intersections] from findRoadPositions [ARRAY]
        _opforTruckCount - Total number of OPFOR supply trucks [NUMBER]
        _civCount        - Number of civilian road vehicles [NUMBER]

    Returns:
        Nothing

    Example(s):
        [0, _roadData, 3, 0] call vgm_s_fnc_amblife_spawnRoadTraffic;
 */

params ["_missionId", "_roadData", "_opforTruckCount", "_civCount"];

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

// --- OPFOR Supply Truck Convoys ---
// Divide total trucks into convoys based on configured size range
private _remaining = _opforTruckCount;
private _convoys = [];
while {_remaining > 0} do {
    private _min = vgm_s_amblife_truckConvoySizeRange # 0;
    private _max = vgm_s_amblife_truckConvoySizeRange # 1;
    private _size = _min + floor random ((_max - _min) + 1);
    _size = _size min _remaining;
    _convoys pushBack _size;
    _remaining = _remaining - _size;
};

private _convoyPositions = [count _convoys, 300] call _fnc_pickRoadPositions;
{
    private _convoyPos = _x;
    private _convoySize = _convoys # _forEachIndex;

    // Build composition: one driver class per truck in the convoy
    private _composition = [];
    for "_i" from 1 to _convoySize do {
        _composition pushBack (selectRandom vgm_s_amblife_opforDriverClasses);
    };

    private _template = [
        _composition,
        _convoyPos,
        _missionId
    ] call vgm_s_fnc_director_getEnemySquadTemplate;

    // Remove btree so Arma's native AI handles driving
    _template deleteAt "btreeName";
    _template set ["deleteOnDespawn", true];
    _template set ["sizeRange", [_convoySize, _convoySize]];
    _template set ["amblife_type", "opforTruck"];
    _template set ["amblife_convoySize", _convoySize];
    _template set ["onSpawn", {
        params ["_squad"];
        private _group = _squad get "group";
        private _units = units _group;
        private _pos = getPos (leader _group);
        private _vehicles = [];

        // Find road direction at spawn point
        private _spawnRoad = roadAt _pos;
        private _roadDir = 0;
        if (!isNull _spawnRoad) then {
            private _connected = roadsConnectedTo _spawnRoad;
            if (count _connected > 0) then {
                _roadDir = _spawnRoad getDir (_connected # 0);
            };
        };

        // Create a truck for each unit, placed on the road facing the travel direction
        {
            private _truckClass = selectRandom vgm_s_amblife_opforTruckClasses;
            // Stagger behind leader along the road direction
            private _offset = _pos getPos [_forEachIndex * 20, _roadDir + 180];
            // Snap to nearest road segment
            private _snapRoad = roadAt _offset;
            if (isNull _snapRoad) then {
                private _nearRoads = _offset nearRoads 30;
                if (count _nearRoads > 0) then {_snapRoad = _nearRoads # 0};
            };
            private _spawnPos = if (!isNull _snapRoad) then {getPos _snapRoad} else {_offset};
            private _truck = createVehicle [_truckClass, _spawnPos, [], 0, "NONE"];
            _truck setDir _roadDir;
            _x moveInDriver _truck;
            _truck forceFollowRoad true;
            _truck limitSpeed 40;
            _truck setVariable ["vgm_missions_gameplay_scouting_spottable", true, true];
            _truck addEventHandler ["Killed", {
                params ["_vehicle", "_killer", "_instigator"];
                private _player = if (!isNull _instigator) then {_instigator} else {_killer};
                if (isNull _player || {!isPlayer _player}) exitWith {};
                [_player, 50] call vgm_s_fnc_leveling_addExperience;
                {hint parseText "<t size='1.1' color='#FFD700'>+50 XP</t><br/><t size='0.85'>Supply truck destroyed</t>"} remoteExec ["call", _player];
            }];
            _vehicles pushBack _truck;
        } forEach _units;

        _squad set ["amblife_vehicles", _vehicles];

        // Set convoy formation and behaviour
        _group setFormation "COLUMN";
        _group setBehaviourStrong "SAFE";
        _group setCombatMode "YELLOW";
        _group setSpeedMode "LIMITED";

        // Walk road network for destination
        private _destPos = [_pos, 800, 1200] call vgm_s_fnc_amblife_walkRoadNetwork;

        if !(_destPos isEqualTo []) then {
            private _wp = _group addWaypoint [_destPos, 10];
            _wp setWaypointType "MOVE";
            _wp setWaypointSpeed "LIMITED";
            _wp setWaypointCompletionRadius 30;

            // Cycle back to start for looping
            private _wpCycle = _group addWaypoint [_pos, 10];
            _wpCycle setWaypointType "CYCLE";
        };

        diag_log format ["[AmbLife] Spawned truck convoy (%1 trucks) at %2", count _vehicles, _pos];
    }];

    [_template] call vgm_s_fnc_virtsquad_create;
} forEach _convoyPositions;

// --- Civilian Road Vehicles ---
private _civPositions = [_civCount, 150] call _fnc_pickRoadPositions;
{
    private _civPos = _x;

    private _squad = createHashMapFromArray [
        ["pos", _civPos],
        ["composition", vgm_s_amblife_civilianClasses],
        ["sizeRange", [1, 1]],
        ["side", civilian],
        ["missionId", _missionId],
        ["deleteOnDespawn", true],
        ["amblife_type", "civVehicle"],
        ["groupVars", createHashMap],
        ["onSpawn", {
            params ["_squad"];
            private _group = _squad get "group";
            private _leader = leader _group;
            private _pos = getPos _leader;

            _leader setCaptive true;

            // Create civilian vehicle at a safe position
            private _vehClass = selectRandom vgm_s_amblife_civVehicleClasses;
            private _safePos = _pos findEmptyPosition [0, 25, _vehClass];
            if (_safePos isEqualTo []) then {
                _safePos = _pos findEmptyPosition [5, 50, _vehClass];
            };
            if (_safePos isEqualTo []) exitWith {
                diag_log format ["[AmbLife] No safe position for civilian vehicle at %1 - skipping vehicle", _pos];
            };
            private _vehicle = createVehicle [_vehClass, _safePos, [], 0, "NONE"];
            _leader moveInDriver _vehicle;

            _squad set ["amblife_vehicle", _vehicle];

            // Set civilian behavior
            _group setBehaviourStrong "SAFE";
            _group setSpeedMode "LIMITED";
            _group setCombatMode "BLUE";

            // Force road following and limit speed
            _vehicle forceFollowRoad true;
            _vehicle limitSpeed 30;

            // Walk road network to find a far destination
            private _destPos = [_pos, 600, 1000] call vgm_s_fnc_amblife_walkRoadNetwork;

            if !(_destPos isEqualTo []) then {
                private _wp = _group addWaypoint [_destPos, 10];
                _wp setWaypointType "MOVE";
                _wp setWaypointSpeed "LIMITED";
                _wp setWaypointCompletionRadius 30;
            };
        }]
    ];

    [_squad] call vgm_s_fnc_virtsquad_create;
} forEach _civPositions;
