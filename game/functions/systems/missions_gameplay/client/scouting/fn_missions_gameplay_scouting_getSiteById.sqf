/*
    File: fn_missions_gameplay_scouting_getSiteById.sqf
    Author: Savage Game Design
    Date: 2024-09-29
    Last Update: 2024-09-29
    Public: No

    Description:
        Get data of site from the mission the player is currently on.

    Parameter(s):
        _siteId - ID of the site [STIRNG]

    Returns:
        Site data [HashMap]

    Example(s):
        [_siteId] call vgm_c_fnc_missions_gameplay_scouting_getSiteById
 */

params ["_siteId"];

private _missionPublic = [] call vgm_c_fnc_missions_getCurrentMission;
if (isNil "_missionPublic") exitWith {
    format ["Unable to get site, not on a mission: %1", _siteId] call vgm_g_fnc_logError;

    createHashMap
};

private _guessedSites = _missionPublic get "system_scouting" get "guessedSites";

private _itemIdx = _guessedSites findIf {_x#4 == _siteId};
if (_itemIdx == -1) exitWith {
    format ["Site does not exist: %1", _siteId] call vgm_g_fnc_logError;

    createHashMap
};

_guessedSites select _itemIdx // return
