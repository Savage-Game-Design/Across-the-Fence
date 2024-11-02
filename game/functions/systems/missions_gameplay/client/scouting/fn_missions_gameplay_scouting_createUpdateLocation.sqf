/*
    File: fn_missions_gameplay_scouting_createUpdateLocation.sqf
    Author: Savage Game Design
    Date: 2024-08-23
    Last Update: 2024-09-30
    Public: No

    Description:
        Creates map location for site.

    Parameter(s):
        _siteId - Id of the site to mark on the map [STRING]

    Returns:
        Map location of the site [LOCATION]

    Example(s):
        [_siteId] call vgm_c_fnc_missions_gameplay_scouting_createUpdateLocation;
 */

params ["_siteId"];

private _entry = [_siteId] call vgm_c_fnc_missions_gameplay_scouting_getSiteById;
_entry params ["", "_siteType", "", "_position"];

if (_position isEqualTo []) exitWith {locationNull};

(vgm_scouting_siteTypes param [vgm_scouting_siteTypes findIf {(_x#1) == _siteType}, []]) params [
    ["_siteName", "-"],
    "",
    ["_siteLocationClass", "o_unknown"]
];

private _fnc_create = {createLocation ["Invisible", [0,0,0], 50, 50]};
private _location = vgm_scouting_locations getOrDefaultCall [_siteId, _fnc_create, true];

_location setType _siteLocationClass;
_location setText format ["%1. %2", parseNumber _siteId + 1, _siteName];
_location setPosition _position;

_location // return
