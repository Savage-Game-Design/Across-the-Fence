/*
    File: fn_amblife_spawnBicycleCouriers.sqf
    Author: AtlasActual
    Date: 2026-03-03
    Last Update: 2026-03-04
    Public: No

    Description:
        Spawns solo OPFOR bicycle couriers between mission sites.
        Alternates between regular bike couriers and cargo mule (bicycle_02).
        No behaviour tree — uses Arma's native AI with forceFollowRoad and
        CYCLE waypoints snapped to nearest road positions. BLUE combat mode
        so solo couriers flee rather than fight.
        Requires 2+ sites in the mission's target zone.

    Parameter(s):
        _missionId - Mission ID [NUMBER]
        _count     - Number of courier units to spawn [NUMBER]

    Returns:
        Nothing

    Example(s):
        [0, 1] call vgm_s_fnc_amblife_spawnBicycleCouriers;
 */

params ["_missionId", "_count"];

if (_count <= 0) exitWith {};

private _mission = [_missionId] call vgm_s_fnc_missions_getById;
if (isNil "_mission") exitWith {};

private _targetZone = _mission get "public" get "targetZone";
private _sites = _targetZone call vgm_s_fnc_missions_zones_getSites;

if (count _sites < 2) exitWith {};

private _sitePositions = _sites apply {_x get "pos"};

// Snap site positions to nearest road for waypoints
private _roadPositions = _sitePositions apply {
    private _nearRoads = _x nearRoads 150;
    if (count _nearRoads > 0) then {
        getPos (_nearRoads # 0)
    } else {
        _x
    };
};

for "_i" from 1 to _count do {
    private _isMule = (_i mod 2) == 0;
    private _bikeClass = if (_isMule) then {"vn_o_bicycle_02"} else {"vn_o_bicycle_01"};

    // Pick a random site as start position
    private _startPos = selectRandom _sitePositions;

    private _template = [
        [selectRandom vgm_s_amblife_bikeMuleClasses],
        _startPos,
        _missionId
    ] call vgm_s_fnc_director_getEnemySquadTemplate;

    // Remove btree so Arma's native AI handles cycling
    _template deleteAt "btreeName";
    _template set ["deleteOnDespawn", true];
    _template set ["sizeRange", [1, 1]];
    _template set ["amblife_type", "bicycleCourier"];
    _template set ["onSpawn", compile format [
        '
        params ["_squad"];
        private _group = _squad get "group";
        private _leader = leader _group;
        private _pos = getPos _leader;

        // Create bicycle at a safe position
        private _bikeClass = "%1";
        private _safePos = _pos findEmptyPosition [0, 15, _bikeClass];
        if (_safePos isEqualTo []) then {
            _safePos = _pos findEmptyPosition [3, 30, _bikeClass];
        };
        if (_safePos isEqualTo []) exitWith {
            diag_log format ["[AmbLife] No safe position for bicycle courier at %%1 - skipping vehicle", _pos];
        };
        private _bike = createVehicle [_bikeClass, _safePos, [], 0, "CAN_COLLIDE"];
        _leader moveInDriver _bike;
        _bike setVariable ["vgm_missions_gameplay_scouting_spottable", true, true];
        vgm_s_amblife_activeBikes pushBack _bike;

        _squad set ["amblife_vehicle", _bike];

        // Force road following
        _bike forceFollowRoad true;

        // Solo couriers: safe behaviour, won''t fight — just flee
        _group setBehaviourStrong "SAFE";
        _group setCombatMode "BLUE";
        _group setSpeedMode "FULL";

        // Waypoints between road-snapped site positions
        private _roadPos = %2;
        private _shuffled = _roadPos call BIS_fnc_arrayShuffle;
        {
            private _wp = _group addWaypoint [_x, 15];
            _wp setWaypointType "MOVE";
            _wp setWaypointSpeed "FULL";
            _wp setWaypointCompletionRadius 20;
        } forEach _shuffled;
        private _wpCycle = _group addWaypoint [_shuffled # 0, 15];
        _wpCycle setWaypointType "CYCLE";
        ',
        _bikeClass,
        _roadPositions
    ]];

    [_template] call vgm_s_fnc_virtsquad_create;
};
