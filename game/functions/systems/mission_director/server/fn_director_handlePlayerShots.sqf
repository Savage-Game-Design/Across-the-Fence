/*
    File: fn_director_handlePlayerShots.sqf
    Author: Savage Game Design
    Date: 2023-09-23
    Last Update: 2023-09-24
    Public: No

    Description:
        Handles aggregated player shooting data reported by the client

    Parameter(s):
        _eventData - Information on recently fired shots [HashMap]

    Returns:
        Nothing

    Example(s):
       [
            "vgm_director_recentPlayerShots",
            createHashMapFromArray [
                ["playerId", getPlayerID player],
                ["totalShots", 0],
                ["averagePosition", [0, 0, 0]],
                ["unsuppressedShots", 0],
                ["suppressedShots", 0]
            ]
        ] call para_g_fnc_event_triggerServer;
 */

params ["_eventData"];

if !([_eventData get "playerId"] call para_s_fnc_remoteExec_validateDirectPlayIdIsRemoteExecOwner) exitWith {};

//hint str _this;

