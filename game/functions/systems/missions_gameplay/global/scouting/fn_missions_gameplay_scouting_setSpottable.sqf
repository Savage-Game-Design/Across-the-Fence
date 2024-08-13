/*
    File: fn_mission_gameplay_scouting_setSpottable.sqf
    Author: Savage Game Design
    Date: 2024-08-11
    Last Update: 2024-08-11
    Public: No

    Description:
        Make object spottable.

    Parameter(s):
        _object - Object 

    Returns:
        Something [BOOL]

    Example(s):
        _object call vgm_g_fnc_missions_gameplay_scouting_setSpottable
 */

params [
    ["_object", objNull, [objNull]]
];

_object setVariable ["vgm_spottable", true, true];
