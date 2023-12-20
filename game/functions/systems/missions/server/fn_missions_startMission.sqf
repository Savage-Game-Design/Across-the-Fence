/*
    File: fn_missions_startMission.sqf
    Author:
    Date: 2023-02-26
    Last Update: 2023-12-20
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

private _mission = [_missionId] call vgm_s_fnc_missions_getById;

if (isNil "_mission") exitWith {
    [format ["Cannot start mission %1 - mission does not exist", _missionId]] call vgm_g_fnc_logError;
};

private _missionPublic = _mission get "public";

if (_missionPublic get "status" isNotEqualTo "CREATED") exitWith {
    ["Attempted to start a mission that has already started"] call vgm_g_fnc_logWarning;
};

[_mission, "IN PROGRESS"] call vgm_s_fnc_missions_updateStatus;
[_mission, "mission started", true] call vgm_s_fnc_missions_preventJoining;

[] remoteExecCall ["vgm_c_fnc_missions_startDeploy", values (_mission get "machineIds")];

[_mission] call vgm_s_fnc_director_startMission;
[_missionPublic get "startPosASL"] call vgm_s_fnc_missions_gameplay_ambient_departHelicopter; // TODO by what and where should this be fired?
// TODO what should setup objects in the mission?
[_mission] call {
    params ["_mission"];
    private _missionPublic = _mission get "public";
    private _pos = _missionPublic get "startPosASL";

    [_mission, ["vn_b_ammobox_01", ASLToAGL _pos]] call vgm_s_fnc_mission_objects_createObject;
};

// TODO
// - Setup extract mechanics
// - Mark target box as occupied? Or is this a mission selection thing?

[] remoteExecCall ["vgm_c_fnc_missions_finishDeploy", values (_mission get "machineIds")];

[
    "vgm_mission_started",
    [_missionPublic get "id"]
] call para_g_fnc_event_triggerGlobal;
