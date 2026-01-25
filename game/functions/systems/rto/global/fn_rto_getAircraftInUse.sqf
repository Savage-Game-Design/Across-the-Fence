/*
    File: fn_rto_getAircraftInUse.sqf
    Author: Savage Game Design
    Date: 2026-01-25
    Last Update: 2026-01-25
    Public: No

    Description:
        Gets the aircraft currently in use by a player

    Parameter(s):
        _playerId - ID of the player to query [PLAYER]

    Returns:
        Array of aircraft ids [STRING]

    Example(s):
        [getPlayerId player] call vgm_g_fnc_rto_getAircraftInUse;
 */

params ["_playerId"];

private _availableAircraft = ["rto_availableAircraft", createHashMap] call para_g_fnc_netmap_getOrDefault getOrDefault [_playerId, createHashMap];

[_availableAircraft] call para_g_fnc_netmap_values
    select {
        [_x] call vgm_g_fnc_rto_isAircraftEnRoute || [_x] call vgm_g_fnc_rto_isAircraftOnStation
    }
    apply {
        _x get "id"
    }
