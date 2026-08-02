#include "script_component.inc"
/*
    File: fn_missions_gameplay_scouting_registerVirtualSite.sqf
    Author: Atlas
    Date: 2026-03-05
    Last Update: 2026-03-05
    Public: No

    Description:
        Registers a virtual site (convoy, BDA, etc.) in the zone's site list
        and creates a corresponding guessed entry in the scouting notepad.
        This allows non-standard encounters (convoys, BDA sites) to be
        scored at mission end like normal sites.

        Called from the BDA system at spawn time and from the client photo
        handler when vehicles are photographed.

    Parameter(s):
        _playerOrMissionId - Player who triggered this, OR mission ID number [OBJECT or NUMBER]
        _siteId     - Deterministic site ID [STRING]
        _sitePos    - Position of the virtual site [ARRAY]
        _siteClass  - Site type classname (e.g. "vgm_convoy", "vgm_bda") [STRING]
        _objects    - Objects belonging to this site (for photo detection) [ARRAY]

    Returns:
        Nothing

    Example(s):
        [player, "vehicle_1234_5678", [1000,2000,0], "vgm_convoy", _vehicles] remoteExecCall ["vgm_s_fnc_missions_gameplay_scouting_registerVirtualSite", 2]
        [_missionId, "bda_1000_2000", [1000,2000,0], "vgm_bda", _objects] call vgm_s_fnc_missions_gameplay_scouting_registerVirtualSite
*/

params ["_playerOrMissionId", "_siteId", "_sitePos", "_siteClass", ["_objects", []]];

if (!isServer) exitWith {};

// Resolve mission from player object or mission ID number
private _mission = if (_playerOrMissionId isEqualType objNull) then {
    if (isNull _playerOrMissionId) exitWith {nil};
    [getPlayerID _playerOrMissionId] call vgm_s_fnc_missions_getAssignedMission
} else {
    [_playerOrMissionId] call vgm_s_fnc_missions_getById
};

if (isNil "_mission") exitWith {
    format ["RegisterVirtualSite: No mission found for %1", _playerOrMissionId] call vgm_g_fnc_logWarning;
};

private _missionId = _mission get "public" get "id";
private _targetZone = _mission get "public" get "targetZone";

// Check if this site ID is already registered (prevent duplicates)
private _zoneSites = vgm_missions_zones_spawnedSites getOrDefault [_targetZone, [], true];
if (_zoneSites findIf {_x get "id" == _siteId} > -1) exitWith {
    format ["RegisterVirtualSite: Site %1 already registered", _siteId] call vgm_g_fnc_logInfo;
};

// Create virtual site hashmap
private _site = createHashMapFromArray [
    ["id", _siteId],
    ["class", _siteClass],
    ["pos", _sitePos select [0, 2]],
    ["objects", _objects],
    ["ownedSites", []],
    ["hiddenTerrain", []],
    ["virtual", true]
];

// Push to server-side site list
_zoneSites pushBack _site;

// Update client-side netmap
private _zoneInfoNetmap = ["vgm_missions_zones_zoneInfoById"] call para_g_fnc_netmap_get;
[_zoneInfoNetmap get _targetZone, "sites", _zoneSites] call para_s_fnc_netmap_set;

// Mark objects as spottable (for photo detection pipeline)
{
    _x setVariable ["vgm_missions_gameplay_scouting_spottable", true, true];
} forEach _objects;

// Trigger siteSpawned event so other systems (like hints) can react
["vgm_sites_siteSpawned", [_site]] call para_g_fnc_event_triggerLocal;

// Bump guessedSitesMax in scouting data
private _data = [_missionId, "scouting"] call vgm_s_fnc_missions_getSystemNetmap;
private _currentMax = _data getOrDefault ["guessedSitesMax", 0];
[_data, "guessedSitesMax", _currentMax + 1] call para_s_fnc_netmap_set;

// Auto-add a guessed entry
private _guessedSites = _data get "guessedSites";
_guessedSites pushBack [
    time,
    "",
    date,
    [],
    _siteId,
    createHashMap
];
[_data, "guessedSites", _guessedSites] call para_s_fnc_netmap_set;

// Trigger client refresh
private _triggerPlayer = if (_playerOrMissionId isEqualType objNull) then {_playerOrMissionId} else {objNull};
["vgm_scouting_addedSiteClient", [_siteId, _triggerPlayer], values (_mission get "machineIds")] call para_g_fnc_event_triggerTargets;

format ["RegisterVirtualSite: Registered %1 site '%2' at %3 for mission %4", _siteClass, _siteId, _sitePos, _missionId] call vgm_g_fnc_logInfo;
