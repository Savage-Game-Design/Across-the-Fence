/*
    File: fn_rto_isAircraftDeparted.sqf
    Author: Savage Game Design
    Date: 2026-01-17
    Last Update: 2026-02-16
    Public: No

    Description:
        Checks if an aircraft has departed

    Parameter(s):
        _aircraft - Aircraft to check [HASHMAP]

    Returns:
        True if aircraft has departed, false otherwise [BOOL]

    Example(s):
        private _aircraft = vgm_s_rto_availableAircraft get _playerId get _aircraftId;

        [_aircraft] call vgm_g_fnc_rto_isAircraftDeparted;
 */

_this call vgm_g_fnc_rto_getAircraftStatus select 0 == "DEPARTED"
