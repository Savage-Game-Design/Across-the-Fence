/*
    File: fn_rto_dismissAircraft.sqf
    Author: Savage Game Design
    Date: 2026-01-08
    Last Update: 2026-02-16
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

[_aircraft] call vgm_g_fnc_rto_getAircraftStatus params ["_aircraftStatus", "_timeRemainingInStatus"];

if !(_aircraftStatus in ["ENROUTE", "ONSTATION"]) exitWith {
    [format [
        "RTO: Player %1 tried to dismiss aircraft %2, but aircraft is %3 for %4",
        _playerId,
        _aircraftId,
        _aircraftStatus,
        [_timeRemainingInStatus] call vgm_g_fnc_formatDuration
    ]] call vgm_g_fnc_logInfo;
};

if (_aircraftStatus isEqualTo "ONSTATION") exitWith {
    [format ["RTO: Player %1 dismissed aircraft %2", _playerId, _aircraftId]] call vgm_g_fnc_logInfo;
    private _aircraftType = vgm_g_rto_aircraftTypes get (_aircraft get "typeId");

    [_aircraft, "departAt", serverTime] call para_s_fnc_netmap_set;
    [_aircraft, "refueledAt", serverTime + (_aircraftType get "refuelTimeSecs")] call para_s_fnc_netmap_set;
};

if (_aircraftStatus isEqualTo "ENROUTE") exitWith {
    [format ["RTO: Player %1 dismissed aircraft %2 while en-route, aircraft returned to base", _playerId, _aircraftId]] call vgm_g_fnc_logInfo;
    // Reset everything to allow the player to call it again if dismissed while en-route.
    [_aircraft, "requestedAt", 1e32] call para_s_fnc_netmap_set;
    [_aircraft, "onStationAt", 1e32] call para_s_fnc_netmap_set;
    [_aircraft, "departAt", 1e32] call para_s_fnc_netmap_set;
    [_aircraft, "refueledAt", 1e32] call para_s_fnc_netmap_set;
};

[format ["RTO: Player %1 tried to dismiss aircraft %2, but it wasn't in a known-good state", _playerId, _aircraftId]] call vgm_g_fnc_logInfo;
