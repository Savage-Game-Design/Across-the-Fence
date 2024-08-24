/*
    File: fn_director_spawnInitialPatrols.sqf
    Author:
    Date: 2023-09-29
    Last Update: 2024-08-24
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
    private _spawnPos = _x get "pos" getPos [10 + random 100, random 360];
    private _group = [vgm_s_director_patrol_classes, east, _spawnPos, _missionPublic get "id"] call vgm_s_fnc_ai_createEnemySquad;
    _group setVariable ["vgm_s_director_command", "patrol"];
    _squads pushBack _group;
} forEach _sites;

[_mission, _squads] call vgm_s_fnc_director_registerGroups;
_mission get "director" set ["initialAiGroups", _squads];

