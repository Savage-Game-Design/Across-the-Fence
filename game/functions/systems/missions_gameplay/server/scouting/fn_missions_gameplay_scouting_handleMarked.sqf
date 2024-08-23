/*
    File: fn_missions_gameplay_scouting_handleMarked.sqf
    Author: Savage Game Design
    Date: 2024-08-23
    Last Update: 2024-08-23
    Public: No

    Description:
        Handle an player attempt at marking the spotted site position.

    Parameter(s):
        _siteId - Id of the site to spot [STRING]
        _markedPos - Position guessed by player [ARRAY]
        _player - Player that did the marking [OBJECT]

    Returns:
        Something [BOOL]

    Example(s):
        [_siteId, _markedPos, _player] call vgm_s_fnc_missions_gameplay_scouting_handleMarked
 */

#define SPOT_DISTANCE_THRESHOLD 50

params ["_siteId", "_markedPos", "_player"];

private _mission = [getPlayerID _player] call vgm_s_fnc_missions_getAssignedMission;
if (isNil "_mission") exitWith {
    format ["Unable to mark site, player not on a mission: %1", _player] call vgm_g_fnc_logError;
};

private _data = [_mission get "public" get "id", "scouting"] call vgm_s_fnc_missions_getSystemNetmap;

if (_siteId in (_data get "markedSites")) exitWith {
    format ["Site is already marked: %1, %2", _siteId, _player] call vgm_g_fnc_logWarning;
};

private _spottedObjects = _data get "objects";

private _spottingData = _spottedObjects get _siteId;
_spottingData params ["", "", "", "", "_sitePos"];

if (isNil "_spottingData") exitWith {
    format ["Marked site does not exist in spotting data: %1, %2", _siteId, _player] call vgm_g_fnc_logError;
};

if (_sitePos distance2d _markedPos > SPOT_DISTANCE_THRESHOLD) exitWith {
    format ["Marked pos too far from site: %1, %2, %3, %4", _siteId, _player, _sitePos, _markedPos] call vgm_g_fnc_logInfo;

    ["vgm_scouting_missedSiteClient", [_siteID, _player], _player] call para_g_fnc_event_triggerTargets;
};

format ["Marking site: %1, %2, %3, %4", _siteId, _player, _sitePos, _markedPos] call vgm_g_fnc_logInfo;

(_data get "markedSites") pushBack _siteId;

["vgm_scouting_markedSiteClient", [_siteId, _player], values (_mission get "machineIds")] call para_g_fnc_event_triggerTargets;
