/*
    File: fn_missions_gameplay_scouting_createLocation.sqf
    Author: Savage Game Design
    Date: 2024-08-23
    Last Update: 2024-08-24
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

private _spottedObjects = _missionPublic get "system_scouting" get "objects";
private _spottedSite = _spottedObjects get _siteId;

if (isNil "_spottedSite") exitWith {
    format ["Unable to create location, site does not exist: %1", _siteId] call vgm_g_fnc_logError;
};

_spottedSite params ["", "_name", "", "", "_pos", "_locationClass"];

private _location = createLocation [_locationClass, _pos, 50, 50];
_location setText localize _name;

vgm_scouting_locations set [_siteId, _location];

_location // return
