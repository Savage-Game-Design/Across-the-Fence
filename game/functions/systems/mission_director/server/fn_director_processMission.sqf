/*
    File: fn_director_processMission.sqf
    Author:
    Date: 2023-09-29
    Last Update: 2024-11-02
    Public: No

    Description:
        Runs periodically to direct a specific mission.

    Parameter(s):
        _mission - Mission to evaluate and update [HashMap]

    Returns:
        Nothing

    Example(s):
        [_mission] call vgm_s_fnc_director_processMission;
 */

params ["_mission"];

private _publicMission = _mission get "public";
private _directorData = _mission get "director";

if (_publicMission get "status" == "FINISHED") exitWith {};

private _missionPlayers = keys (_mission get "machineIds") apply { getUserInfo _x # 10 };

private _dynamicGroups = _directorData get "dynamicAiGroups";

private _alertness = _directorData get "alertness";

private _timeSinceLastTracker = serverTime - (_directorData get "lastTrackerSent");
private _currentTrackerDelay = linearConversion [
        0, vgm_s_director_max_alertness,
        _alertness,
        vgm_s_director_max_time_between_trackers_secs, vgm_s_director_min_time_between_trackers_secs,
        true
];
private _randomExtraTime = random 120;

// Spawn a new tracker!
if (_timeSinceLastTracker + _randomExtraTime > _currentTrackerDelay && count _dynamicGroups < vgm_s_director_dynamic_max_groups) then {
    private _target = selectRandom _missionPlayers;
    if (isNil "_target" || {isNull _target}) exitWith {};
    private _spawnPos = [getPos _target] call para_g_fnc_spawning_find_valid_position_tracer select 0;
    private _group = [vgm_s_director_patrol_classes, east, _spawnPos, _publicMission get "id"] call vgm_s_fnc_ai_createEnemySquad;

    _group setVariable ["orders", ["pursue", _publicMission get "group"], true];
    _group setVariable ["vgm_s_director_command", "track"];


    [_mission, [_group]] call vgm_s_fnc_director_registerGroups;
    _directorData get "dynamicAiGroups" pushBack _group;

    _directorData set ["lastTrackerSent", serverTime];
};


// TODO - Spawn in attack units if engaged in combat, and not enough nearby patrols.

// Remove any invalid groups that don't need to be monitored.
private _invalidGroups = (_directorData get "aiGroups") select {isNull _x || {alive _x} count units _x == 0};
_directorData set ["aiGroups", (_directorData get "aiGroups") - _invalidGroups];
_directorData set ["dynamicAiGroups", (_directorData get "dynamicAiGroups") - _invalidGroups];

