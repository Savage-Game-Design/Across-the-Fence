#include "script_component.inc"
/*
    File: fn_missions_gameplay_scouting_handleSetSiteType.sqf
    Author: Savage Game Design
    Date: 2024-09-26
    Last Update: 2025-02-14
    Public: No

    Description:
        Handle an player setting type of the site.

    Parameter(s):
        _siteId - ID of the site [STRING]
        _siteType - Site type [STRING]
        _player - Player that set the type [OBJECT]

    Returns:
        Nothing

    Example(s):
        [_siteId, _data, _player] call vgm_s_fnc_missions_gameplay_scouting_handleSetSitePhoto
 */

params [
    ["_siteId", ""],
    ["_siteType", ""],
    ["_player", objNull]
];

private _mission = [getPlayerID _player] call vgm_s_fnc_missions_getAssignedMission;
if (isNil "_mission") exitWith {
    format ["Unable to set site type, player not on a mission: %1", _player] call vgm_g_fnc_logError;
};

private _data = [_mission get "public" get "id", "scouting"] call vgm_s_fnc_missions_getSystemNetmap;

private _guessedSites = _data get "guessedSites";

// TODO move to shared function
private _itemIdx = _guessedSites findIf {_x#IDX_ID == _siteId};
if (_itemIdx == -1) exitWith {
    format ["Unable to set site type, site does not exist: %1", _siteId] call vgm_g_fnc_logError;
};

format ["Setting site type: %1, %2, %3", _siteId, _siteType, _player] call vgm_g_fnc_logInfo;

(_guessedSites select _itemIdx) set [IDX_TYPE, _siteType];

[_data, "guessedSites", _guessedSites] call para_s_fnc_netmap_set;

["vgm_scouting_siteTypeChangedClient", [_siteId, _player], values (_mission get "machineIds")] call para_g_fnc_event_triggerTargets;
