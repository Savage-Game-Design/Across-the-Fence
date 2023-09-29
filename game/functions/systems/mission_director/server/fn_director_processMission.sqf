/*
    File: fn_director_processMission.sqf
    Author:
    Date: 2023-09-29
    Last Update: 2023-09-29
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

#define UNSUPPRESSED_LISTEN_RANGE 250
#define SUPPRESSED_LISTEN_RANGE 100
#define EXPLOSION_LISTEN_RANGE 350

params ["_mission"];

private _publicMission = _mission get "public";
private _directorData = _mission get "director";

if (_publicMission get "status" == "FINISHED") exitWith {};

private _recentShots = _directorData get "shotsIngestionQueue";
private _recentUnsuppressedShots = _recentShots select { _x get "unsuppressedShots" > 0 };
private _recentUnsuppressedShotsPositions = _recentUnsuppressedShots apply { _x get "averagePosition" };
private _recentSuppressedShots = _recentShots select { _x get "suppressedShots" > 0 };
private _recentSuppressedShotsPositions = _recentSuppressedShots apply { _x get "averagePosition" };
private _recentExplosions = _directorData get "explosionIngestionQueue";
private _recentExplosionsPositions = _recentExplosions apply { _x get "pos" };

// Order shots and explosions by most recent first.
reverse _recentShots;
reverse _recentExplosions;

// Empty the queues for the next iteration.
_directorData set ["shotsIngestionQueue", []];
_directorData set ["explosionIngestionQueue", []];

private _groupsToDelete = [];


{
    // TODO Prune distant groups

    private _group = _x;
    private _currentCommand = _group getVariable "vgm_s_director_command";

    if ({alive _x} count units _group == 0 || isNull _group) then {
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
    if (_currentCommand == "investigate" && {(_group getVariable "orders" select 1) distance2D leader _group < 50 && combatBehaviour _group != "COMBAT"}) then {
        if (random 1 < 0.99) then {
            _currentCommand = "track";
            _group setVariable ["orders", ["pursue", _publicMission get "group"], true];
        };
    };

    _group setVariable ["vgm_s_director_command", _currentCommand];
} forEach (_directorData get "aiGroups");

{
    _directorData set ["aiGroups", (_directorData get "aiGroups") - _groupsToDelete];
} forEach _groupsToDelete;
