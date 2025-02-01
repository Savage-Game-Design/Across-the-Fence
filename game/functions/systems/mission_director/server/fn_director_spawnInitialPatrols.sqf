/*
    File: fn_director_spawnInitialPatrols.sqf
    Author:
    Date: 2023-09-29
    Last Update: 2025-01-16
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

params ["_mission"];

private _missionPublic = _mission get "public";
private _targetZone = _missionPublic get "targetZone";
private _sites = [_targetZone] call vgm_s_fnc_missions_zones_getSites;

private _squads = [];

private _patrolTemplate = [[], [0,0,0], _missionPublic get "id"] call vgm_s_fnc_director_getEnemySquadTemplate;
private _defenseTemplate = [[], [0,0,0], _missionPublic get "id"] call vgm_s_fnc_director_getEnemySquadTemplate;

{
    private _defenseUnitCount = vgm_s_director_defenseSquadSizes get (_x get "type" get "size");
    private _spawnPos = _x get "pos" getPos [10 + random 30, random 360];

    _patrolTemplate set ["pos", _spawnPos];
    _patrolTemplate set ["composition", vgm_s_director_patrol_classes select [0, 2 + ceil random 2]];
    private _patrolSquad = [_patrolTemplate] call vgm_s_fnc_virtsquad_create;

    _defenseTemplate set ["pos", _x get "pos"];
    _defenseTemplate set ["composition", vgm_s_director_defense_classes select [0, _defenseUnitCount]];
    _defenseTemplate get "groupVars" pushBack
        ["vgm_g_order", createHashMapFromArray [
            ["type", "DEFEND"],
            ["pos", _x get "pos"]
        ]];

    private _defenseSquad = [_defenseTemplate] call vgm_s_fnc_virtsquad_create;

    _squads pushBack _patrolSquad;
    _squads pushBack _defenseSquad;
} forEach _sites;
