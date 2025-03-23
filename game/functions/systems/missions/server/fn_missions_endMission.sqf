/*
    File: fn_missions_endMission.sqf
    Author:
    Date: 2023-02-26
    Last Update: 2025-02-28
    Public: No

    Description:
        Ends a mission - it may be in-progress, or not yet started.

    Parameter(s):
        _missionId - ID of mission to end [NUMBER]

    Returns:
        Nothing

    Example(s):
        [31, "SUCCESS"] call vgm_s_fnc_missions_endMission;
        [32, "FAILURE"] call vgm_s_fnc_missions_endMission;
 */

params ["_missionId", ["_endType", "SUCCESS"]];

private _mission = [_missionId] call vgm_s_fnc_missions_getById;

if (isNil "_mission") exitWith {};

private _missionPublic = _mission get "public";

[_mission, "FINISHED"] call vgm_s_fnc_missions_updateStatus;

private _missionMemberPlayerIds = (_missionPublic get "players") call para_g_fnc_netmap_keys;
private _missionMemberMachineIds = values (_mission get "machineIds");

// award experience for mission performance and show mission end screen on client
{
    private _player = getUserInfo _x param [10, objNull];

    private _levelingDataCopy = +(_player getVariable "vgm_g_levelingData");
    private _milestones = [_endType, _x] call vgm_s_fnc_missions_calculateMilestones;

    [_endType, _levelingDataCopy, _milestones] remoteExecCall ["vgm_c_fnc_missions_endMission", _player];

    _milestones params ["", "_totalExperience"];
    [_player, _totalExperience] call vgm_s_fnc_leveling_addExperience;
} forEach _missionMemberPlayerIds;

[
    "vgm_mission_ended",
    [_missionPublic get "id", _endType]
] call para_g_fnc_event_triggerGlobal;

private _marker = _missionPublic call vgm_g_fnc_missions_getZoneMarker;
{deleteVehicle _x} forEach (allMines inAreaArray _marker);
[_missionPublic get "targetZone"] call vgm_s_fnc_missions_zones_clearSites;
[_missionPublic get "targetZone"] call vgm_s_fnc_missions_zones_freeZone;
[_mission] call vgm_s_fnc_director_stopMission;

{
    [_x, _mission] call vgm_s_fnc_missions_removePlayerFromMission;
} forEach _missionMemberPlayerIds;

localNamespace getVariable "vgm_missions" deleteAt (_missionPublic get "id");
[
    ["vgm_missions_publicMissionInfo"] call para_g_fnc_netmap_get,
    _missionPublic get "id"
] call para_s_fnc_netmap_deleteAt;

// Terminate public netmap, and all owned netmaps (all children should be owned)
[_missionPublic] call para_s_fnc_netmap_terminate;

// TODO
// Disable damage
// Needs to handle downed or dead players
