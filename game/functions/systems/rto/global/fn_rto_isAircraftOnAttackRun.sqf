/*
    File: fn_rto_isAircraftOnAttackRun.sqf
    Author: Savage Game Design
    Date: 2026-01-17
    Last Update: 2026-01-25
    Public: No

    Description:
        Checks if an aircraft is currently on an attack run

    Parameter(s):
        _aircraft - Aircraft to check [HASHMAP]

    Returns:
        True if aircraft is on an attack run, false otherwise [BOOL]

    Example(s):
        private _aircraft = vgm_s_rto_availableAircraft get _playerId get _aircraftId;

        [_aircraft] call vgm_g_fnc_rto_isAircraftOnAttackRun;
 */

params ["_aircraft"];

(_aircraft get "runCompleteAt") <= serverTime
