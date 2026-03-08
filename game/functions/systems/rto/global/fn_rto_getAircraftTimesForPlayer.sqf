/*
    File: fn_rto_getAircraftTimesForPlayer.sqf
    Author: Savage Game Design
    Date: 2026-03-08
    Last Update: 2026-03-11
    Public: No

    Description:
        Gets the various times (arrival, on-station, etc) for an aircraft called right now by a specific player.

    Parameter(s):
        _unit - Player calling the strike [STRING]
        _aircraft - Aircraft to call [HASHMAP]

    Returns:
        Various times, in the format: [
            ["arrivalTimeSecs", NUMBER],
            ["onStationTimeSecs", NUMBER],
            ["refuelTimeSecs", NUMBER],
        ] [HASHMAP]

    Example(s):
        [player, _aircraft] call vgm_g_fnc_rto_getAircraftTimesForPlayer;
 */

params ["_unit", "_aircraft"];

private _aircraftType = vgm_g_rto_aircraftTypes get (_aircraft get "typeId");

private _modifiers = [_unit] call vgm_g_fnc_rto_getTimeModifiersForPlayer;

createHashMapFromArray [
    ["arrivalTimeSecs", (_aircraftType get "arrivalTimeSecs") * (_modifiers get "arrivalTimeMult" get "total")],
    ["onStationTimeSecs", (_aircraftType get "onStationTimeSecs") * (_modifiers get "onStationTimeMult" get "total")],
    ["refuelTimeSecs", (_aircraftType get "refuelTimeSecs") * (_modifiers get "refuelTimeMult" get "total")],
    ["strikeDelaySecs", _modifiers get "strikeDelaySecs"]
]
