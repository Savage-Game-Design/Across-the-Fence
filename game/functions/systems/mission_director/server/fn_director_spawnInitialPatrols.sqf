/*
    File: fn_director_spawnInitialPatrols.sqf
    Author:
    Date: 2023-09-29
    Last Update: 2024-11-02
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

{
    private _defenseUnitCount = vgm_s_director_defenseSquadSizes getOrDefault [_x get "type" get "size"];
    private _spawnPos = _x get "pos" getPos [10 + random 100, random 360];
    private _group1 = [vgm_s_director_patrol_classes select [0, 2 + ceil random 2], east, _spawnPos, _missionPublic get "id"] call vgm_s_fnc_ai_createEnemySquad;
    private _group2 = [vgm_s_director_defense_classes select [0, _defenseUnitCount], east, _spawnPos, _missionPublic get "id"] call vgm_s_fnc_ai_createEnemySquad;
    _group2 setVariable ["vgm_g_order", createHashMapFromArray [
        ["type", "DEFEND"],
        ["pos", _x get "pos"]
    ]];
    _squads pushBack _group1;
    _squads pushBack _group2;
} forEach _sites;

[_mission, _squads] call vgm_s_fnc_director_registerGroups;
_mission get "director" set ["initialAiGroups", _squads];

