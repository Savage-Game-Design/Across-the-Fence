/*
    File: fn_sites_hints_place.sqf
    Author: Savage Game Design
    Date: 2024-10-25
    Last Update: 2024-11-29
    Public: No

    Description:
        Place hint objects around the site.

    Parameter(s):
        _mission - Mission data or ID [NUMBER, HASHMAP]
        _site - Site data [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [_mission, _site] call vgm_s_fnc_sites_hints_place
 */

// #define DEBUG

params ["_mission", "_site"];

private _missionId = _mission get "public" get "id";
private _zone = _mission call vgm_g_fnc_missions_getZoneMarker;
private _center = _site get "pos";
// ignore sites outside of our mission zone
// sites do not keep track of what mission they're spawned in
if !(_center inArea _zone) exitWith {};

private _config = (_site get "class") call vgm_s_fnc_sites_hints_getConfig;

private _r1 = _config get "radius";
private _r2 = _config get "radiusSafezone";

private _circleAreaOuter = Pi * _r1^2;
private _circleAreaInner = Pi * _r2^2;
// objects per 1 km^2
private _density = _config get "density";

private _amount = (_circleAreaOuter - _circleAreaInner) / (1000*1000) * _density;
private _objects = vgm_sites_hints_objects getOrDefault [_missionId, [], true];

private _classes = _config get "classes";
for "_i" from 0 to _amount do {

    private _spawnPos = [];
    for "_p" from 0 to 25 do {
        private _pos = [_center, _r1, _r2] call vgm_g_fnc_randomPosInRing;
        if (_pos inArea _zone) exitWith {_spawnPos = _pos};
    };
    if (_spawnPos isEqualTo []) then {
        format ["Failed to place hint for %1 in %2", _center, _missionId] call vgm_g_fnc_logWarning;
        continue;
    };

    _objects pushBack ([
        _mission,
        [selectRandom _classes, _spawnPos, random 360, {call vgm_c_fnc_sites_hints_initObject}, [_center]]
    ] call vgm_s_fnc_mission_objects_createObject);

#ifdef DEBUG
    _m = createMarkerLocal [format ["%1_%2", _center, _i], _spawnPos];
    _m setMarkerTypeLocal "hd_dot";
    _m setMarkerColor "ColorRed";
#endif
};
