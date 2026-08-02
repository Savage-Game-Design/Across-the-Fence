/*
    File: fn_amblife_spawnWorkParties.sqf
    Author: AtlasActual
    Date: 2026-03-03
    Last Update: 2026-03-05
    Public: No

    Description:
        Spawns OPFOR road work parties (3-4 soldiers) that patrol roads on foot
        in COLUMN formation with CYCLE waypoints. Each soldier carries a shovel
        attached to their back. Start SAFE, react via btree.

    Parameter(s):
        _missionId - Mission ID [NUMBER]
        _roadData  - [roadSegments, intersections] from findRoadPositions [ARRAY]
        _count     - Number of work parties to spawn [NUMBER]

    Returns:
        Nothing

    Example(s):
        [0, _roadData, 1] call vgm_s_fnc_amblife_spawnWorkParties;
 */

params ["_missionId", "_roadData", "_count"];

if (_count <= 0) exitWith {};

_roadData params ["_roads", "_intersections"];
if (count _roads < 4) exitWith {};

// Pick spread-out road positions
private _spawnPositions = [];
private _available = +_roads;
for "_i" from 1 to _count do {
    if (count _available == 0) exitWith {};
    private _road = selectRandom _available;
    private _pos = getPos _road;
    _spawnPositions pushBack _pos;
    _available = _available select {getPos _x distance2D _pos >= 200};
};

{
    private _spawnPos = _x;

    private _template = [
        vgm_s_director_patrol_classes,
        _spawnPos,
        _missionId
    ] call vgm_s_fnc_director_getEnemySquadTemplate;

    _template set ["deleteOnDespawn", true];
    _template set ["sizeRange", [3, 4]];
    _template set ["onSpawn", {
        params ["_squad"];
        private _group = _squad get "group";
        private _pos = getPos (leader _group);

        // Attach shovel to each unit's back, track for cleanup
        private _missionId = _squad get "missionId";
        private _missionObjects = vgm_s_amblife_missionObjects getOrDefault [_missionId, []];
        {
            private _shovel = "Land_vn_shovel_f" createVehicle [0, 0, 0];
            _shovel attachTo [_x, [0.15, -0.2, 0.15], "Spine3"];
            _shovel setVectorDirAndUp [[0, 0, 1], [0, -1, 0]];
            _x setVariable ["vgm_s_amblife_shovel", _shovel];
            _missionObjects pushBack _shovel;

            _x addEventHandler ["Deleted", {
                params ["_unit"];
                private _shovel = _unit getVariable ["vgm_s_amblife_shovel", objNull];
                if (!isNull _shovel) then { deleteVehicle _shovel };
            }];
        } forEach units _group;

        // Road patrol: SAFE, LIMITED, COLUMN with CYCLE waypoints
        _group setFormation "COLUMN";
        _group setBehaviourStrong "SAFE";
        _group setCombatMode "YELLOW";
        _group setSpeedMode "LIMITED";

        // Walk road network for destination
        private _destPos = [_pos, 400, 800] call vgm_s_fnc_amblife_walkRoadNetwork;

        if !(_destPos isEqualTo []) then {
            private _wp = _group addWaypoint [_destPos, 10];
            _wp setWaypointType "MOVE";
            _wp setWaypointSpeed "LIMITED";
            _wp setWaypointCompletionRadius 20;

            private _wpCycle = _group addWaypoint [_pos, 10];
            _wpCycle setWaypointType "CYCLE";
        } else {
            // Fallback: HOLD if no road network found
            private _wp = _group addWaypoint [_pos, 0];
            _wp setWaypointType "HOLD";
        };

        diag_log format ["[AmbLife] Spawned work party (%1 units) at %2", count units _group, _pos];
    }];

    [_template] call vgm_s_fnc_virtsquad_create;
} forEach _spawnPositions;
