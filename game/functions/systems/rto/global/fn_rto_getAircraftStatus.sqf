/*
    File: fn_rto_getAircraftStatus.sqf
    Author: Savage Game Design
    Date: 2026-01-25
    Last Update: 2026-02-16
    Public: No

    Description:
        Gets the status of an aircraft

    Parameter(s):
        _aircraft - Aircraft to check [HASHMAP]

    Returns:
        Status - one of:
            ["REFUELING", timeRemainingToRefuel]
            ["STANDBY, 0],
            ["ENROUTE", timeRemainingToArrive]
            ["ONSTATION", timeRemainingBeforeDeparture]

    Example(s):
        [_aircraft] call vgm_g_fnc_rto_getAircraftStatus;
 */

params ["_aircraft"];


// This is effectively a circular state machine.
// A more powerful implementation for server-side aircraft would be a state machine with enter / exit methods.
// The one advantage of this is it's much more efficient (no server-side periodic checks)
if ((_aircraft get "refueledAt") <= serverTime) exitWith { ["STANDBY",   0] };
if ((_aircraft get "departAt") <= serverTime)       exitWith { ["REFUELING", ((_aircraft get "refueledAt")  - serverTime) max 0] };
if ((_aircraft get "onStationAt") <= serverTime)    exitWith { ["ONSTATION", ((_aircraft get "departAt")    - serverTime) max 0] };
if ((_aircraft get "requestedAt") <= serverTime)    exitWith { ["ENROUTE",   ((_aircraft get "onStationAt") - serverTime) max 0] };
if ((_aircraft get "onStandbyAt") <= serverTime)    exitWith { ["STANDBY",   0] };

["REFUELING", ((_aircraft get "onStandbyAt") - serverTime) max 0]
