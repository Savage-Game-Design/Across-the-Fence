/*
    File: fn_rto_getAircraftStatus.sqf
    Author: Savage Game Design
    Date: 2026-01-25
    Last Update: 2026-01-25
    Public: No

    Description:
        Gets the status of an aircraft

    Parameter(s):
        _aircraft - Aircraft to check [HASHMAP]

    Returns:
        Status - one of "STANDBY", "ENROUTE", "ONSTATION", "DEPARTED" [STRING]

    Example(s):
        [_aircraft] call vgm_g_fnc_rto_getAircraftStatus;
 */

params ["_aircraft"];

if ([_aircraft] call vgm_g_fnc_rto_isAircraftDeparted) exitWith { "DEPARTED" };
if ([_aircraft] call vgm_g_fnc_rto_isAircraftOnStation) exitWith { "ONSTATION" };
if ([_aircraft] call vgm_g_fnc_rto_isAircraftEnRoute) exitWith { "ENROUTE" };

"STANDBY"
