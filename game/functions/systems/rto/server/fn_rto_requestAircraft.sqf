/*
    File: fn_rto_requestAircraft.sqf
    Author: Savage Game Design
    Date: 2026-01-08
    Last Update: 2026-02-20
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
private _aircraft = _allAircraft get _aircraftId;

if (isNil "_aircraft") exitWith {
    [format ["RTO: Player %1 requested aircraft %2, but aircraft does not exist", _playerId, _aircraftId]] call vgm_g_fnc_logWarning;
};

[_aircraft] call vgm_g_fnc_rto_getAircraftStatus params ["_aircraftStatus"];

if (_aircraftStatus isNotEqualTo "STANDBY") exitWith {
    [format ["RTO: Player %1 requested aircraft %2, but aircraft is %3", _playerId, _aircraftId, _aircraftStatus]] call vgm_g_fnc_logInfo;
};

private _aircraftType = vgm_g_rto_aircraftTypes get (_aircraft get "typeId");

[_aircraft, "requestedAt", serverTime] call para_s_fnc_netmap_set;
private _onStationAt = serverTime + (_aircraftType get "arrivalTimeSecs");
[_aircraft, "onStationAt", _onStationAt] call para_s_fnc_netmap_set;
private _departAt = _onStationAt + (_aircraftType get "onStationTimeSecs");
[_aircraft, "departAt", _departAt] call para_s_fnc_netmap_set;
private _refueledAt = _departAt + (_aircraftType get "refuelTimeSecs");
[_aircraft, "refueledAt", _refueledAt] call para_s_fnc_netmap_set;

// Refresh strikes at this point to allow refueled aircraft needing to be fully reset.
private _strikes = createHashMap;
{
    _strikes set [_x, _y get "uses"];
} forEach (_aircraftType get "strikes");
[_aircraft, "strikes", _strikes] call para_s_fnc_netmap_set;

[format [
    "RTO: Player %1 requested aircraft %2 and it has been dispatched. Time: %3, on station at: %4, departing at: %5, refueled at: %6",
    _playerId,
    _aircraftId,
    serverTime,
    _onStationAt,
    _departAt,
    _refueledAt
]] call vgm_g_fnc_logInfo;
