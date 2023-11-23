/*
    File: fn_missions_startMission.sqf
    Author:
    Date: 2023-02-26
    Last Update: 2023-11-23
    Public: Yes

    Description:
        Starts the mission for all players

    Parameter(s):
        _missionId - ID of the mission to start [NUMBER]

    Returns:
        Nothing

    Example(s):
        [32] call vgm_s_fnc_missions_startMission
*/

params ["_missionId"];

private _mission = localNamespace getVariable "vgm_missions" get _missionId;

if (isNil "_mission") exitWith {
    [format ["Cannot start mission %1 - mission does not exist", _missionId]] call vgm_g_fnc_logError;
};

private _missionPublic = _mission get "public";

if (_missionPublic get "status" isNotEqualTo "CREATED") exitWith {
    ["Attempted to start a mission that has already started"] call vgm_g_fnc_logWarning;
};

[_mission, "IN PROGRESS"] call vgm_s_fnc_missions_updateStatus;
[_mission, "mission started", true] call vgm_s_fnc_missions_preventJoining;

_mission call compile getText (vgm_missions_config >> (_missionPublic get "type") >> "deploy" >> "onStartServer");
[] remoteExecCall ["vgm_c_fnc_missions_startDeploy", values (_mission get "machineIds")];

[_mission] call vgm_s_fnc_missions_spawnMission;

// TODO
// - Setup extract mechanics
// - Mark target box as occupied? Or is this a mission selection thing?

_mission call compile getText (vgm_missions_config >> (_missionPublic get "type") >> "deploy" >> "onFinishServer");
[] remoteExecCall ["vgm_c_fnc_missions_finishDeploy", values (_mission get "machineIds")];

[
    "vgm_mission_started",
    [_missionPublic get "id"]
] call para_g_fnc_event_triggerGlobal;
