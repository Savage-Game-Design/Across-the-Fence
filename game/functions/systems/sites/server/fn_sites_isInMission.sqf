/*
    File: fn_sites_isInMission.sqf
    Author: Savage Game Design
    Date: 2025-01-15
    Last Update: 2025-01-17
    Public: Yes

    Description:
        Checks if site is in the zone of the mission.

    Parameter(s):
        _site - Site to check [HASHMAP]
        _mission - Mission [HASHMAP]

    Returns:
        In mission zone? [BOOL]

    Example(s):
        [_site, _mission] call vgm_s_fnc_sites_isInMission
 */

params ["_site", "_mission"];

private _zone = _mission call vgm_g_fnc_missions_getZoneMarker;
private _center = _site get "pos";

_center inArea _zone // return
