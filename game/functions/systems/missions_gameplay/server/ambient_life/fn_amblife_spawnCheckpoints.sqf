/*
    File: fn_amblife_spawnCheckpoints.sqf
    Author: AtlasActual
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Spawns OPFOR checkpoints at road intersections (preferred) or regular
        road segments (fallback). Each checkpoint has two Land_vn_o_shelter_05
        shelters facing opposite directions along the road, with AI positioned
        inside them. Shelters have simulation disabled so they don't block
        AI pathfinding.

    Parameter(s):
        _missionId - Mission ID [NUMBER]
        _roadData  - [roadSegments, intersections] from findRoadPositions [ARRAY]
        _count     - Number of checkpoints to spawn [NUMBER]

    Returns:
        Nothing

    Example(s):
        [0, _roadData, 4] call vgm_s_fnc_amblife_spawnCheckpoints;
 */

params ["_missionId", "_roadData", "_count"];

_roadData params ["_roads", "_intersections"];

if (_count <= 0 || count _roads < 4) exitWith {};

private _objects = vgm_s_amblife_missionObjects get _missionId;

// Build position pool: intersections first, then road segments as fallback
private _positions = +_intersections;

// If we need more than we have intersections, fill from spread-out road segments
if (_count > count _positions) then {
    private _available = +_roads;
    // Remove roads too close to already-chosen intersection positions
    {
        private _iPos = _x;
        _available = _available select {getPos _x distance2D _iPos >= 150};
    } forEach _positions;

    private _needed = _count - count _positions;
    for "_i" from 1 to _needed do {
        if (count _available == 0) exitWith {};
        private _road = selectRandom _available;
        private _pos = getPos _road;
        _positions pushBack _pos;
        _available = _available select {getPos _x distance2D _pos >= 150};
    };
};

// Spawn checkpoints at chosen positions
for "_i" from 1 to (_count min count _positions) do {
    private _pos = _positions # (_i - 1);

    // Determine road direction
    private _nearRoad = (_pos nearRoads 10) # 0;
    private _roadDir = 0;
    if (!isNil "_nearRoad" && {!isNull _nearRoad}) then {
        private _conn = roadsConnectedTo _nearRoad;
        if (count _conn > 0) then {
            _roadDir = _nearRoad getDir (_conn # 0);
        };
    };

    // Place two shelters along the road, facing opposite directions
    // Shelter A faces along the road, Shelter B faces the opposite way
    private _shelterPositions = [];
    {
        private _dir = [_roadDir, _roadDir + 180] # _forEachIndex;
        private _offset = [1, -1] # _forEachIndex;
        private _shelterPos = _pos vectorAdd [_offset * 5 * sin _roadDir, _offset * 5 * cos _roadDir, 0];
        private _shelter = createSimpleObject ["Land_vn_o_shelter_05", _shelterPos, true];
        _shelter setDir _dir;
        _shelter enableSimulationGlobal false;
        _objects pushBack _shelter;
        _shelterPositions pushBack [_shelterPos, _dir];
    } forEach [0, 1];

    // Spawn OPFOR checkpoint squad — store shelter data for onSpawn
    private _template = [
        vgm_s_director_patrol_classes,
        _pos,
        _missionId
    ] call vgm_s_fnc_director_getEnemySquadTemplate;

    _template set ["deleteOnDespawn", false];
    _template set ["sizeRange", [2, 3]];
    _template set ["shelterPositions", _shelterPositions];
    _template set ["onSpawn", {
        params ["_squad"];
        private _group = _squad get "group";
        private _shelters = _squad get "shelterPositions";

        _group setBehaviourStrong "SAFE";
        _group setSpeedMode "LIMITED";

        // Place units in their shelters
        private _units = units _group;
        {
            if (_forEachIndex < count _shelters) then {
                private _shelterData = _shelters # _forEachIndex;
                _x setPosATL (_shelterData # 0);
                _x setDir (_shelterData # 1);
                _x setUnitPos "MIDDLE";
                doStop _x;
            };
        } forEach _units;

        // HOLD at checkpoint position
        private _wp = _group addWaypoint [getPos leader _group, 0];
        _wp setWaypointType "HOLD";
    }];

    [_template] call vgm_s_fnc_virtsquad_create;
};
