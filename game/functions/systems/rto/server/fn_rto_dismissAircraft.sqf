/*
    File: fn_rto_dismissAircraft.sqf
    Author: Savage Game Design
    Date: 2026-01-08
    Last Update: 2026-01-17
    Public: No

    Description:
        Dismiss an aircraft that's currently on-station.

    Parameter(s):
        _playerId - Player dismissing the aircraft [STRING]
        _aircraftId - Aircraft on-station [STRING]

    Returns:
        Nothing

    Example(s):
        [getPlayerId allPlayers # 0, "f100"] call vgm_s_fnc_rto_dismissAircraft;
 */

params ["_playerId", "_aircraftId"];

private _aircraft = vgm_s_rto_availableAircraft get _playerId get _aircraftId;

if (isNil "_aircraft") exitWith {
    [format ["RTO: Player %1 tried to dismiss aircraft %2, but aircraft does not exist", _playerId, _aircraftId]] call vgm_g_fnc_logWarning;
};

if ([_aircraft] call vgm_g_fnc_rto_isAircraftDeparted) exitWith {
    [format ["RTO: Player %1 tried to dismiss aircraft %2, but aircraft has already been used", _playerId, _aircraftId]] call vgm_g_fnc_logInfo;
};

if ([_aircraft] call vgm_g_fnc_rto_isAircraftOnStation) exitWith {
    [format ["RTO: Player %1 dismissed aircraft %2", _playerId, _aircraftId]] call vgm_g_fnc_logInfo;
    [_aircraft, "departAt", serverTime] call para_s_fnc_netmap_set;
};

if ([_aircraft] call vgm_g_fnc_rto_isAircraftEnRoute) exitWith {
    [format ["RTO: Player %1 dismissed aircraft %2 while en-route, aircraft returned to base", _playerId, _aircraftId]] call vgm_g_fnc_logInfo;
    // Reset everything to allow the player to call it again if dismissed while en-route.
    [_aircraft, "requestedAt", 1e99] call para_s_fnc_netmap_set;
    [_aircraft, "onStationAt", 1e99] call para_s_fnc_netmap_set;
    [_aircraft, "departAt", 1e99] call para_s_fnc_netmap_set;
};

[format ["RTO: Player %1 tried to dismiss aircraft %2, but it hasn't been dispatched", _playerId, _aircraftId]] call vgm_g_fnc_logInfo;
