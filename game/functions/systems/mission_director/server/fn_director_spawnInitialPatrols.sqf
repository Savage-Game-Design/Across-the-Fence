/*
    File: fn_director_spawnInitialPatrols.sqf
    Author:
    Date: 2023-09-29
    Last Update: 2024-03-08
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

private _insertionLocation = _mission get "public" get "startPosASL";
private _objective = markerPos "marker_47";

private _desiredSquads = vgm_s_director_patrol_max_groups;

private _angleToObjective = _insertionLocation getDir _objective;
private _spawnAngles = [_angleToObjective + 90, _angleToObjective - 90];
private _spawnIntervalDistance = (_insertionLocation distance2D _objective) /_desiredSquads;

private _squads = [];

for "_i" from 1 to _desiredSquads do {
    private _spawnCenterlinePos = _insertionLocation getPos [_spawnIntervalDistance * _i, _angleToObjective];
    private _spawnPos = _spawnCenterlinePos getPos [100 + random 100, selectRandom _spawnAngles];

    private _group = [vgm_s_director_patrol_classes, east, _spawnPos, _mission get "id"] call vgm_s_fnc_ai_createEnemySquad;
    _group setVariable ["vgm_s_director_command", "patrol"];
    _squads pushBack _group;
};

[_mission, _squads] call vgm_s_fnc_director_registerGroups;
_mission get "director" set ["initialAiGroups", _squads];
