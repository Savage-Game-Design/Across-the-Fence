/*
    File: fn_director_processMission.sqf
    Author:
    Date: 2023-09-29
    Last Update: 2024-03-08
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

private _recentShots = _directorData get "shotsIngestionQueue";
private _recentExplosions = _directorData get "explosionIngestionQueue";

// Order shots and explosions by most recent first.
reverse _recentShots;
reverse _recentExplosions;

// Number of player "shooting reports" that contain unsuppressed shots.
// E.g If a player shot twice, waited 5 seconds, shot again. Another player shot once. We'd have 3 reports.
// 2 reports from player 1, and 1 from player. The immediate second shot from player 1 wouldn't count,
// as it's in the same reporting window.
private _recentUnsuppressedShots = _recentShots select { _x get "unsuppressedShots" > 0 };
private _recentUnsuppressedShotsPositions = _recentUnsuppressedShots apply { _x get "averagePosition" };
private _recentSuppressedShots = _recentShots select { _x get "suppressedShots" > 0 };
private _recentSuppressedShotsPositions = _recentSuppressedShots apply { _x get "averagePosition" };
private _recentExplosionsPositions = _recentExplosions apply { _x get "pos" };

// Empty the queues for the next iteration.
_directorData set ["shotsIngestionQueue", []];
_directorData set ["explosionIngestionQueue", []];

private _alertness =
    (_directorData get "alertness")
    + count _recentUnsuppressedShots
    + count _recentSuppressedShots * 0.5;

_directorData set ["alertness", _alertness];

private _groupsToDelete = [];

// Handle AI behaviour
{
    private _group = _x;
    private _currentCommand = _group getVariable "vgm_s_director_command";

    private _shouldDelete =
        // No group
        isNull _group
        // No alive AI
        || {alive _x} count units _group == 0;

    if (_shouldDelete) then {
        _groupsToDelete pushBack _group;
        continue;
    };

    private _nearbyUnsuppressedShotsPositions = _recentUnsuppressedShotsPositions inAreaArray [getPos leader _group, vgm_s_director_unsuppressed_listen_range, vgm_s_director_unsuppressed_listen_range, 0, false];
    private _nearbySuppressedShotsPositions = _recentSuppressedShotsPositions inAreaArray [getPos leader _group, vgm_s_director_suppressed_listen_range, vgm_s_director_suppressed_listen_range, 0, false];
    private _nearbyExplosionPositions = _recentExplosionsPositions inAreaArray [getPos leader _group, vgm_s_director_explosion_listen_range, vgm_s_director_explosion_listen_range, 0, false];

    [format ["Processing squad %1, nearby noises: %2", _group, count _nearbyUnsuppressedShotsPositions + count _nearbySuppressedShotsPositions + count _nearbyExplosionPositions]] call vgm_g_fnc_logDebug;

    // Sends them off to investigate nearby noises
    if (_currentCommand in ["investigate", "patrol"]) then {
        private _newInvestigatePosition = [];

        private _shotPositions = [_nearbySuppressedShotsPositions # 0, _nearbyUnsuppressedShotsPositions # 0] select {!isNil "_x"};

        switch (count _shotPositions) do {
            case 1: {
                _newInvestigatePosition = _shotPositions # 0;
            };
            case 2: {
                _newInvestigatePosition = _shotPositions select (_shotPositions # 0 get "time" < _shotPositions # 1 get "time");
            };
            default {
                if (count _nearbyExplosionPositions > 0) then {
                    _newInvestigatePosition = _nearbyExplosionPositions # 0;
                };
            };
        };

        if (_newInvestigatePosition isNotEqualTo []) then {
            _newInvestigatePosition set [2, 0];
            [format ["Redirecting squad %1 to investigate shots at %2", _group, _newInvestigatePosition]] call vgm_g_fnc_logDebug;
            _currentCommand = "investigate";
            _group setVariable ["orders", ["attack", _newInvestigatePosition], true];
        };
    };

    // At the investigate target, not in combat, random chance to track players.
    if (_currentCommand == "investigate") then {
        private _investigatePos = (_group getVariable "orders" select 1);

        // Continue if group is near to investigate position, and not engaged.
        if (_investigatePos distance2D leader _group > 50 || combatBehaviour _group == "COMBAT") exitWith {};

        if (random 1 < vgm_s_director_investigate_track_chance) then {
            _currentCommand = "track";
            _group setVariable ["orders", ["pursue", _publicMission get "group"], true];
        } else {
            _currentCommand = "patrol";
            _group setVariable ["orders", ["patrol", _investigatePos, 100], true];
        }
    };

    // TODO - Make trackers shoot in the air, because it's cool.

    _group setVariable ["vgm_s_director_command", _currentCommand];
} forEach (_directorData get "aiGroups");

private _dynamicGroups = _directorData get "dynamicAiGroups";

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

// Clean up any AI groups that need deleting.
{
    {
        deleteVehicle _x;
    } forEach units _x;

    deleteGroup _x;
} forEach _groupsToDelete;

_directorData set ["aiGroups", (_directorData get "aiGroups") - _groupsToDelete];
_directorData set ["dynamicAiGroups", (_directorData get "dynamicAiGroups") - _groupsToDelete];

