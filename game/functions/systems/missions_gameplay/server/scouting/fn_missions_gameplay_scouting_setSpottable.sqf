/*
    File: fn_mission_gameplay_scouting_setSpottable.sqf
    Author: Savage Game Design
    Date: 2024-08-11
    Last Update: 2024-08-17
    Public: No

    Description:
        Make object spottable.

    Parameter(s):
        _object - Object that is spottable [OBJECT]
        _site - Site that owns the object [HASHMAP]

    Returns:
        Something [BOOL]

    Example(s):
        _object call vgm_g_fnc_missions_gameplay_scouting_setSpottable
 */

params [
    ["_object", objNull, [objNull]],
    ["_site", nil, [createHashMap]]
];

_object setVariable ["vgm_missions_gameplay_scouting_spottable", true, true];
_object setVariable ["vgm_missions_gameplay_scouting_site", _site];
