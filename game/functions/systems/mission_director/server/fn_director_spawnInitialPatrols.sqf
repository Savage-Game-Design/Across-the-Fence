/*
    File: fn_director_spawnInitialPatrols.sqf
    Author:
    Date: 2023-09-29
    Last Update: 2025-10-25
    Public: No

    Description:
        Creates initial patrols on mission start.

    Parameter(s):
        _mission - Mission to create patrols for [HashMap]

    Returns:
        Nothing

    Example(s):
        [_mission] call vgm_s_fnc_director_spawnInitialPatrols
 */

#define INTERSITE_PATROL_MAX_DIST 600

params ["_mission"];

private _missionPublic = _mission get "public";
private _director = _mission get "director";
private _targetZone = _missionPublic get "targetZone";
private _sites = [_targetZone] call vgm_s_fnc_missions_zones_getSites;
private _sitePositions = _sites apply {_x get "pos"};

private _squads = [];

private _patrolTemplate = [[], [0,0,0], _missionPublic get "id"] call vgm_s_fnc_director_getEnemySquadTemplate;
private _intersitePatrolTemplate = [[], [0,0,0], _missionPublic get "id"] call vgm_s_fnc_director_getEnemySquadTemplate;
private _defenseTemplate = [[], [0,0,0], _missionPublic get "id"] call vgm_s_fnc_director_getEnemySquadTemplate;

private _zombieTemplate = [[], [0,0,0], _missionPublic get "id"] call vgm_s_fnc_director_getZombieSquadTemplate;

private _zombieSiteTypeChances = _director get "zombieSiteTypeChances";
[_missionPublic] call vgm_s_fnc_missions_getFullness params ["_playerCount", "_maxPlayers", "_missionFullness"];

if (_director getOrDefault ["spawnAmbientZombies", false]) then {
    _squads = _squads + ([_mission] call vgm_s_fnc_director_spawnAmbientZombies);
};

{
    private _sitePos = _x get "pos";
    private _siteRadius = vgm_s_sites_siteRadii get (_x get "type" get "size");

    private _defenseUnitSizeRange = vgm_s_director_defenseSquadSizeRanges get (_x get "type" get "size");
    private _spawnPos = _sitePos getPos [_siteRadius + random 30, random 360];

    private _zombieSiteType = keys _zombieSiteTypeChances selectRandomWeighted values _zombieSiteTypeChances;

    if (_zombieSiteType in ["ALL_ZOMBIES"]) then {
        private _quantity = linearConversion [0, 1, _missionFullness, 4, 5 + random 4];
        for "_i" from 1 to _quantity do {
            _zombieTemplate set ["pos", _spawnPos];
            private _zombieClass = (selectRandom vgm_s_director_patrol_classes) + (selectRandomWeighted vgm_s_director_staticZombieWeightings);
            _zombieTemplate set ["composition", [_zombieClass]];
            private _zombieSquad = [_zombieTemplate] call vgm_s_fnc_virtsquad_create;
            _squads pushBack _zombieSquad;
        };
    } else {
        _patrolTemplate set ["pos", _spawnPos];
        _patrolTemplate set ["composition", vgm_s_director_patrol_classes];
        _patrolTemplate set ["sizeRange", [2, 3 + ceil random 3]];
        private _patrolSquad = [_patrolTemplate] call vgm_s_fnc_virtsquad_create;
        _squads pushBack _patrolSquad;
    };

    private _nearbySiteIndexes = (_sitePositions inAreaArrayIndexes [_sitePos, INTERSITE_PATROL_MAX_DIST, INTERSITE_PATROL_MAX_DIST]) - [_forEachIndex];
    if (_zombieSiteType in ["MIXED", "ALL_OPFOR"] && _nearbySiteIndexes isNotEqualTo []) then {
        // Try to spawn the intersite patrol just outside of the site.
        private _targetSite = _sites select (selectRandom _nearbySiteIndexes);
        _intersitePatrolTemplate set ["pos", _sitePos getPos [_siteRadius + 15, random 360]];
        _intersitePatrolTemplate set ["composition", vgm_s_director_patrol_classes];
        _intersitePatrolTemplate set ["sizeRange", [2, 4 + ceil random 2]];
        _intersitePatrolTemplate get "groupVars" set ["vgm_g_order", [
            createHashMapFromArray [
                ["type", "PATROL-ROUTE"],
                ["route", [_sitePos, _targetSite get "pos"]]
            ]
        ]];
        private _intersitePatrolSquad = [_intersitePatrolTemplate] call vgm_s_fnc_virtsquad_create;
        _squads pushBack _intersitePatrolSquad;
    };

    if (_zombieSiteType in ["ALL_ZOMBIES", "MIXED"]) then {
        private _quantity = linearConversion [0, 1, _missionFullness, 4, 5 + random 4];
        for "_i" from 1 to _quantity do {
            _zombieTemplate set ["pos", _x get "pos"];
            private _zombieClass = (selectRandom vgm_s_director_defense_classes) + (selectRandomWeighted vgm_s_director_staticZombieWeightings);
            _zombieTemplate set ["composition", [_zombieClass]];
            private _zombieSquad = [_zombieTemplate] call vgm_s_fnc_virtsquad_create;
            _squads pushBack _zombieSquad;
        };
    } else {
        _defenseTemplate set ["pos", _x get "pos"];
        _defenseTemplate set ["composition", vgm_s_director_defense_classes];
        _defenseTemplate set ["sizeRange", _defenseUnitSizeRange];
        _defenseTemplate get "groupVars" set ["vgm_g_order", [
            createHashMapFromArray [
                ["type", "DEFEND"],
                ["pos", _x get "pos"]
            ]
        ]];

        private _defenseSquad = [_defenseTemplate] call vgm_s_fnc_virtsquad_create;

        _squads pushBack _defenseSquad;
    };
} forEach _sites;

_squads
