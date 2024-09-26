/*
    File: fn_missions_gameplay_scouting_handleMarked.sqf
    Author: Savage Game Design
    Date: 2024-08-23
    Last Update: 2024-09-26
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

params ["_siteId", "_markedPos", "_player"];

private _mission = [getPlayerID _player] call vgm_s_fnc_missions_getAssignedMission;
if (isNil "_mission") exitWith {
    format ["Unable to mark site, player not on a mission: %1", _player] call vgm_g_fnc_logError;
};

private _data = [_mission get "public" get "id", "scouting"] call vgm_s_fnc_missions_getSystemNetmap;

private _guessedSites = _data get "guessedSites";

// TODO move to shared function
private _itemIdx = _guessedSites findIf {_x#4 == _siteId};
if (_itemIdx == -1) exitWith {
    format ["Unable to mark site, site does not exist: %1", _siteId] call vgm_g_fnc_logError;
};

format ["Marking site: %1, %2, %3", _siteId, _player, _markedPos] call vgm_g_fnc_logInfo;

(_guessedSites select _itemIdx) set [3, _markedPos];

[_data, "guessedSites", _guessedSites] call para_s_fnc_netmap_set;

["vgm_scouting_markedSiteClient", [_siteId, _player], values (_mission get "machineIds")] call para_g_fnc_event_triggerTargets;
