/*
    File: fn_sites_hints_markOnMap.sqf
    Author: Savage Game Design
    Date: 2024-12-16
    Last Update: 2024-12-16
    Public: No

    Description:
        Marks hint object on a map.

    Parameter(s):
        _object - Object to mark on the map [OBJECT]

    Returns:
        Nothing

    Example(s):
        [_object] call vgm_c_fnc_sites_hints_markOnMap
 */

params ["_object"];

private _sitePos = _object getVariable "vgm_sites_hints_sitePos";

private _marker = createMarkerLocal [format ["vgm_sites_hints_%1", _object], getPosATL _object];
_marker setMarkerTypeLocal "mil_arrow";
_marker setMarkerColorLocal "ColorBlack";

private _dir = [_object, _sitePos] call vgm_g_fnc_spokenDirection;
private _idx = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"] find _dir;
_marker setMarkerDirLocal (45 * _idx);
