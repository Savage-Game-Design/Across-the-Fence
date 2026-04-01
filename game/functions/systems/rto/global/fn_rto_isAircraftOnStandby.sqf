/*
    File: fn_rto_isAircraftOnStandby.sqf
    Author: Savage Game Design
    Date: 2026-01-17
    Last Update: 2026-02-16
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

_this call vgm_g_fnc_rto_getAircraftStatus select 0 == "STANDBY"
