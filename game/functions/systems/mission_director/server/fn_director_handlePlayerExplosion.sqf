/*
    File: fn_director_handlePlayerExplosion.sqf
    Author: Savage Game Design
    Date: 2023-09-23
    Last Update: 2023-09-29
    Public: No

    Description:
        Handles clients reporting player-caused explosions.

    Parameter(s):
        _eventData - Information about the explosion [HashMap]

    Returns:
        Nothing

    Example(s):
        [
            "vgm_director_playerCausedExplosion",
            createHashMapFromArray [
                ["playerId", getPlayerID player],
                ["pos", _pos]
            ]
        ] call para_g_fnc_event_triggerServer;
 */

params ["_eventData"];

private _playerId = _eventData get "playerId";

if !([_playerId] call para_s_fnc_remoteExec_validateDirectPlayIdIsRemoteExecOwner) exitWith {};

private _mission = [_playerId] call vgm_s_fnc_missions_getAssignedMission;

if (isNil "_mission") exitWith {
    [format ["Player %1 reported explosion, but isn't assigned to a mission", _playerId]] call vgm_g_fnc_logWarning;
};

_mission get "director" get "explosionIngestionQueue" pushBack _eventData;
