/*
    File: fn_director_spawnInitialPatrols.sqf
    Author:
    Date: 2023-09-29
    Last Update: 2025-04-04
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
private _targetZone = _missionPublic get "targetZone";
private _sites = [_targetZone] call vgm_s_fnc_missions_zones_getSites;
private _sitePositions = _sites apply {_x get "pos"};

private _squads = [];

private _patrolTemplate = [[], [0,0,0], _missionPublic get "id"] call vgm_s_fnc_director_getEnemySquadTemplate;
private _intersitePatrolTemplate = [[], [0,0,0], _missionPublic get "id"] call vgm_s_fnc_director_getEnemySquadTemplate;
private _defenseTemplate = [[], [0,0,0], _missionPublic get "id"] call vgm_s_fnc_director_getEnemySquadTemplate;

{
    private _sitePos = _x get "pos";
    private _siteRadius = vgm_s_sites_siteRadii get (_x get "type" get "size");

    private _defenseUnitSizeRange = vgm_s_director_defenseSquadSizeRanges get (_x get "type" get "size");
    private _spawnPos = _sitePos getPos [_siteRadius + random 30, random 360];

    _patrolTemplate set ["pos", _spawnPos];
    _patrolTemplate set ["composition", vgm_s_director_patrol_classes];
    _patrolTemplate set ["sizeRange", [2, 3 + ceil random 3]];
    private _patrolSquad = [_patrolTemplate] call vgm_s_fnc_virtsquad_create;
    _squads pushBack _patrolSquad;

    private _nearbySiteIndexes = (_sitePositions inAreaArrayIndexes [_sitePos, INTERSITE_PATROL_MAX_DIST, INTERSITE_PATROL_MAX_DIST]) - [_forEachIndex];
    if (_nearbySiteIndexes isNotEqualTo []) then {
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
} forEach _sites;
