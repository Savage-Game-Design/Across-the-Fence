/*
    File: fn__missions_gameplay_scouting_handleSpotted.sqf
    Author: Savage Game Design
    Date: 2024-08-17
    Last Update: 2024-08-22
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [player, cursorObject] call vgm_s_fnc_missions_gameplay_scouting_handleSpotted;
 */

params ["_spotter", "_target"];

private _site = _target getVariable "vgm_missions_gameplay_scouting_site";
if (isNil "_site") exitWith {
    format ["Unable to spot target without a site: %1, %2", _spotter, getPosWorld _target] call vgm_g_fnc_logError;
};

private _mission = [getPlayerID _spotter] call vgm_s_fnc_missions_getAssignedMission;
if (isNil "_mission") exitWith {
    format ["Unable to spot target, spotter not on a mission: %1", _spotter] call vgm_g_fnc_logError;
};

private _data = [_mission get "public" get "id", "scouting"] call vgm_s_fnc_missions_getSystemNetmap;
private _spottedObjects = _data get "objects";

// object site already spotted
if ((_site get "id") in _spottedObjects) exitWith {};

_spottedObjects set [_site get "id", [
    time, // used for sorting
    _site get "type" get "name", // site display type
    "",      // grid (not confirmed by player yet)
    date    // spot time
]];
[_data, "objects", _spottedObjects] call para_s_fnc_netmap_set;

["vgm_scouting_spottedSiteClient", [_site get "id", _spotter], values (_mission get "machineIds")] call para_g_fnc_event_triggerTargets;
