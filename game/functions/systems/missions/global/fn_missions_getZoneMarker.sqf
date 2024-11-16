/*
    File: fn_missions_getZoneMarker.sqf
    Author: Savage Game Design
    Date: 2024-10-22
    Last Update: 2024-11-15
    Public: Yes

    Description:
        Get zone marker of a mission.

    Parameter(s):
        _zone - ID of the zone or mission hash map, server or public [STRING, HASHMAP]

    Returns:
        Zone marker [STRING]

    Example(s):
        ["1"] call vgm_g_fnc_missions_getZoneMarker
 */

params [
    ["_zone", "", ["", createHashMap]]
];

// handle public and server mission hash map
if (_zone isEqualType createHashMap) then {
    if ("public" in _zone) then {
        _zone = _zone get "public";
    };

    _zone = _zone get "targetZone";
};

[_zone] call vgm_g_fnc_loc_getTargetBoxMarker // return
