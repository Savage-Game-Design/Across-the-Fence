/*
    File: fn_missions_endMission.sqf
    Author:
    Date: 2023-02-26
    Last Update: 2023-06-20
    Public: No

    Description:
        Ends a mission - it may be in-progress, or not yet started.

    Parameter(s):
        _missionId - ID of mission to end [NUMBER]

    Returns:
        Nothing

    Example(s):
        [32] call vgm_s_fnc_missions_endMission;
 */

params ["_missionId"];

private _missionsData = localNamespace getVariable "vgm_missions_data";
private _mission = _missionsData get "missions" get _missionId;

if (isNil "_mission") exitWith {};

[_mission, "FINISHED"] call vgm_s_fnc_missions_updateStatus;

private _missionMemberPlayerIds = keys (_mission get "players");
private _missionMemberMachineIds = values (_mission get "machineIds");

[] remoteExecCall ["vgm_c_fnc_missions_endMission", _missionMemberMachineIds];

[
    "mission ended",
    [_mission get "id"]
] call para_g_fnc_event_triggerGlobal;

{
    [_x, _mission] call vgm_s_fnc_missions_removePlayerFromMission;
} forEach _missionMemberPlayerIds;

_missionsData get "missions" deleteAt _missionId;

[_mission] call vgm_s_fnc_missions_updateMissionDataOnClients;

// TODO
// Disable damage
// Needs to handle downed or dead players
// Award XP?
