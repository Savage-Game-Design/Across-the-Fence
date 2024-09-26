/*
    File: fn_missions_gameplay_scouting_createLocation.sqf
    Author: Savage Game Design
    Date: 2024-08-23
    Last Update: 2024-09-26
    Public: No

    Description:
        Creates map location for site.

    Parameter(s):
        _siteId - Id of the site to mark on the map [STRING]

    Returns:
        Map location of the site [LOCATION]

    Example(s):
        [_siteId] call vgm_c_fnc_missions_gameplay_scouting_createLocation;
 */

params ["_siteId"];

private _missionPublic = [] call vgm_c_fnc_missions_getCurrentMission;
if (isNil "_missionPublic") exitWith {
    format ["Unable to create location for site, no mission: %1", _siteId] call vgm_g_fnc_logError;
};

private _guessedSites = _missionPublic get "system_scouting" get "guessedSites";

// TODO move to shared function
private _itemIdx = _guessedSites findIf {_x#4 == _siteId};
if (_itemIdx == -1) exitWith {
    format ["Unable to create location for site, site does not exist: %1", _siteId] call vgm_g_fnc_logError;
};

private _entry = _guessedSites select _itemIdx;

_entry params ["", "_siteType", "", "_position"];

(vgm_scouting_siteTypes param [vgm_scouting_siteTypes findIf {(_x#1) == _siteType}]) params ["_siteName", "", "_siteLocationClass"];

private _location = createLocation [_siteLocationClass, _position, 50, 50];
_location setText _siteName;

deleteLocation (vgm_scouting_locations getOrDefault [_siteId, locationNull]);
vgm_scouting_locations set [_siteId, _location];

_location // return
