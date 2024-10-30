/*
    File: fn_sites_hints_place.sqf
    Author: Savage Game Design
    Date: 2024-10-25
    Last Update: 2024-10-27
    Public: No

    Description:
        Place hint objects around the site.

    Parameter(s):
        _mission - Mission data or ID [NUMBER, HASHMAP]
        _site - Site data [HASHMAP]

    Returns:
        Something [BOOL]

    Example(s):
        [_mission, _site] call vgm_s_fnc_sites_hints_place
 */

#define DEBUG

params ["_mission", "_site"];

private _zone = _mission call vgm_g_fnc_missions_getZoneMarker;
private _center = _site get "pos";
// ignore sites outside of our mission zone
// sites do not keep track of what mission they're spawned in
if !(_center inArea _zone) exitWith {};

private _r1 = 250; // radius
private _r2 = 100; // inner radius

private _circleAreaOuter = Pi * _r1^2;
private _circleAreaInner = Pi * _r2^2;
// objects per 1 km^2
private _density = 100;

private _amount = (_circleAreaOuter - _circleAreaInner) / (1000*1000) * _density;
private _objects = vgm_sites_hints_objects getOrDefault [_mission get "public" get "id", [], true];

for "_i" from 0 to _amount do {
    private _spawnPos = [_center, _r1, _r2] call vgm_g_fnc_randomPosInRing;

    _objects pushBack ([
        _mission,
        ["Land_vn_canisterfuel_f", _spawnPos, random 360, {call vgm_c_fnc_sites_hints_initObject}, [_center]]
    ] call vgm_s_fnc_mission_objects_createObject);

#ifdef DEBUG
    _m = createMarker [format ["%1_%2", _center, _i], _spawnPos];
    _m setMarkerType "hd_dot";
    _m setMarkerColor "ColorRed";
#endif
};
