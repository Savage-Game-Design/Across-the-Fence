/*
    File: fn_rto_requestAircraft.sqf
    Author: Savage Game Design
    Date: 2026-01-08
    Last Update: 2026-01-17
    Public: No

    Description:
        Requests an aircraft that's currently on standby arrive on-station.

    Parameter(s):
        _playerId - Player requesting the aircraft [STRING]
        _aircraftId - Aircraft to come on-station [STRING]

    Returns:
        Nothing

    Example(s):
        [getPlayerId allPlayers # 0, "f100"] call vgm_s_fnc_rto_requestAircraft;
 */

params ["_playerId", "_aircraftId"];

private _allAircraft = vgm_s_rto_availableAircraft get _playerId;

if (values _allAircraft findIf {[_x] call vgm_g_fnc_rto_isAircraftEnRoute || [_x] call vgm_g_fnc_rto_isAircraftOnStation} > -1) exitWith {
    [format ["RTO: Player %1 requested aircraft %2, but an aircraft is already on-station or en-route", _playerId, _aircraftId]] call vgm_g_fnc_logInfo;
};

private _aircraft = _allAircraft get _aircraftId;

if (isNil "_aircraft") exitWith {
    [format ["RTO: Player %1 requested aircraft %2, but aircraft does not exist", _playerId, _aircraftId]] call vgm_g_fnc_logWarning;
};

if ([_aircraft] call vgm_g_fnc_rto_isAircraftDeparted) exitWith {
    [format ["RTO: Player %1 requested aircraft %2, but aircraft has already been used", _playerId, _aircraftId]] call vgm_g_fnc_logInfo;
};

private _aircraftType = vgm_g_rto_aircraftTypes get (_aircraft get "typeId");

[_aircraft, "requestedAt", serverTime] call para_s_fnc_netmap_set;
private _onStationAt = serverTime + (_aircraftType get "arrivalTimeSecs");
[_aircraft, "onStationAt", _onStationAt] call para_s_fnc_netmap_set;
private _departAt = _onStationAt + (_aircraftType get "onStationTimeSecs");
[_aircraft, "departAt", _departAt] call para_s_fnc_netmap_set;

[format [
    "RTO: Player %1 requested aircraft %2 and it has been dispatched. Time: %3, on station at: %4, departing at: %5",
    _playerId,
    _aircraftId,
    serverTime,
    _onStationAt,
    _departAt
]] call vgm_g_fnc_logInfo;
