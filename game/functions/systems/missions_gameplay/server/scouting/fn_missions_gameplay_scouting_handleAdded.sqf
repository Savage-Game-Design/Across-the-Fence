/*
    File: fn_missions_gameplay_scouting_handleAdded.sqf.sqf
    Author: Savage Game Design
    Date: 2024-09-26
    Last Update: 2024-09-29
    Public: No

    Description:
        Handle an player attempt at adding new site to the list.

    Parameter(s):
        _player - Player that did the adding [OBJECT]

    Returns:
        Something [BOOL]

    Example(s):
        [_siteId, _markedPos, _player] call vgm_s_fnc_missions_gameplay_scouting_handleMarked
 */

params ["_player"];

private _mission = [getPlayerID _player] call vgm_s_fnc_missions_getAssignedMission;
if (isNil "_mission") exitWith {
    format ["Unable to add site, player not on a mission: %1", _player] call vgm_g_fnc_logError;
};

private _data = [_mission get "public" get "id", "scouting"] call vgm_s_fnc_missions_getSystemNetmap;
private _guessedSites = _data get "guessedSites";

private _limit = _data get "guessedSitesMax";
if (count _guessedSites >= _limit) exitWith {
    format ["Site limit reached: %1", _player] call vgm_g_fnc_logWarning;
};

format ["Adding site: %1", _player] call vgm_g_fnc_logInfo;

private _id = missionNamespace getVariable ["vgm_scouting_siteId", 0];
missionNamespace setVariable ["vgm_scouting_siteId", _id+1];

_guessedSites pushBack ([
    time, // used for sorting
    "", // site type
    date, // add time time, for display
    [], // guessed position
    str _id
]);
[_data, "markedSites", _guessedSites] call para_s_fnc_netmap_set;

["vgm_scouting_addedSiteClient", [_player], values (_mission get "machineIds")] call para_g_fnc_event_triggerTargets;
