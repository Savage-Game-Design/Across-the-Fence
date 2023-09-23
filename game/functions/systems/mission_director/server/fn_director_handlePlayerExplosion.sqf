/*
    File: fn_director_handlePlayerExplosion.sqf
    Author: Savage Game Design
    Date: 2023-09-23
    Last Update: 2023-09-24
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

if !([_eventData get "playerId"] call para_s_fnc_remoteExec_validateDirectPlayIdIsRemoteExecOwner) exitWith {};

// hint str _this;
