/*
    File: fn_rto_isAircraftEnRoute.sqf
    Author: Savage Game Design
    Date: 2026-01-17
    Last Update: 2026-01-17
    Public: No

    Description:
        Checks if an aircraft is currently en-route

    Parameter(s):
        _aircraft - Aircraft to check [HASHMAP]

    Returns:
        True if aircraft is en-route, false otherwise [BOOL]

    Example(s):
        private _aircraft = vgm_s_rto_availableAircraft get _playerId get _aircraftId;

        [_aircraft] call vgm_g_fnc_rto_isAircraftEnRoute;
 */

params ["_aircraft"];

(_aircraft get "requestedAt") <= serverTime && serverTime < (_aircraft get "onStationAt")
