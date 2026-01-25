/*
    File: fn_rto_requestStrike.sqf
    Author: Savage Game Design
    Date: 2026-01-14
    Last Update: 2026-01-25
    Public: No

    Description:
        Requests an available aircraft that's on-station perform a strike

    Parameter(s):
        _playerId - Player requesting the strike [STRING]
        _aircraftId - Type of aircraft to perform the strike, must be available and on station [STRING]
        _strike - Strike type [STRING]
        _startPos - Strike start position [Pos2D]
        _endPos - Strike end position [Pos2D]

    Returns:
        Nothing

    Example(s):
        [
            getPlayerId player,
            "test_aircraft",
            [100, 100],
            [200, 200]
        ] call vgm_s_fnc_rto_requestStrike
 */

params ["_playerId", "_aircraftId", "_strike", "_startPos", "_endPos"];

private _aircraft = vgm_s_rto_availableAircraft get _playerId get _aircraftId;

if (isNil "_aircraft") exitWith {
    [format ["RTO: Player %1 requested strike from aircraft %2, but aircraft does not exist", _playerId, _aircraftId]] call vgm_g_fnc_logWarning;
};

private _strikes = _aircraft get "strikes";
if (_strikes getOrDefault [_strike, 0] <= 0) exitWith {
    [format ["RTO: Player %1 requested strike from aircraft %2, but strike %3 is not available", _playerId, _aircraftId, _strike]] call vgm_g_fnc_logInfo;
};

private _onStationAt = _aircraft get "onStationAt";
private _departAt = _aircraft get "departAt";
if !( [_aircraft] call vgm_g_fnc_rto_isAircraftOnStation ) exitWith {
    [format [
        "RTO: Player %1 requested strike from aircraft %2, but aircraft is not on station. Time: %3, on station at: %4, depart at: %5",
        _playerId,
        _aircraftId,
        serverTime,
        _onStationAt,
        _departAt
    ]] call vgm_g_fnc_logInfo;
};

private _runCompleteAt = _aircraft get "runCompleteAt";
if !(_runCompleteAt <= serverTime) exitWith {
    [format [
        "RTO: Player %1 requested strike from aircraft %2, but aircraft is on an attack run. Time: %3, run complete at: %4",
        _playerId,
        _aircraftId,
        serverTime,
        _runCompleteAt
    ]] call vgm_g_fnc_logInfo;
};

private _aircraftType = vgm_g_rto_aircraftTypes get (_aircraft get "typeId");

// Approximate time for the run to complete - when testing, it took about 65 seconds for a plane to despawn, which feels like too long between runs.
[_aircraft, "runCompleteAt", serverTime + 45] call para_s_fnc_netmap_set;
// Remove a charge of the strike
_strikes set [_strike, (_strikes get _strike) - 1];
// Refresh the netmap entry (broadcast to all players)
[_aircraft, "strikes", _strikes] call para_s_fnc_netmap_set;

private _runIndex = 1;
// Prevents the dialog for completing an attack run from playing.
private _totalRuns = 1e32;
private _vehicleClass = _aircraftType get "vehicleClass";
private _vehicleConfig = _aircraftType get "vehicleConfig";
private _magazines = _aircraftType get "strikes" get _strike get "magazines";
private _illumination = 0;

[format [
    "RTO: Player %1 requested strike from aircraft %2 with %3 from position %4 to position %5 - beginning strike",
    _playerId,
    _aircraftId,
    _strike,
    _startPos,
    _endPos
]] call vgm_g_fnc_logInfo;

[
    _runIndex,
    _vehicleConfig,
    _vehicleClass,
    [_startPos # 0, _startPos # 1, 0],
    [_endPos # 0, _endPos # 1, 0],
    _totalRuns,
    _magazines,
    _playerId call vgm_s_fnc_player_fromId,
    _illumination
] spawn vn_fnc_artillery_plane;
