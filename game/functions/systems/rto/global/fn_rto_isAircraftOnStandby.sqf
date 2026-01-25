/*
    File: fn_rto_isAircraftOnStandby.sqf
    Author: Savage Game Design
    Date: 2026-01-17
    Last Update: 2026-01-25
    Public: No

    Description:
        Checks if an aircraft is on standby waiting to be called

    Parameter(s):
        _aircraft - Aircraft to check [HASHMAP]

    Returns:
        True if aircraft is on standby, false otherwise [BOOL]

    Example(s):
        private _aircraft = vgm_s_rto_availableAircraft get _playerId get _aircraftId;

        [_aircraft] call vgm_g_fnc_rto_isAircraftOnStandby;
 */

params ["_aircraft"];

!(
    [_aircraft] call vgm_g_fnc_rto_isAircraftDeparted
    || [_aircraft] call vgm_g_fnc_rto_isAircraftEnRoute
    || [_aircraft] call vgm_g_fnc_rto_isAircraftOnStation
)
