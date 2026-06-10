/*
    File: fn_missions_startMission.sqf
    Author:
    Date: 2023-02-26
    Last Update: 2026-04-15
    Public: Yes

    Description:
        Starts the mission for all players

    Parameter(s):
        _missionId - ID of the mission to start [NUMBER]

    Returns:
        Error code if the mission couldn't be started, or nil if no error [STRING]

    Example(s):
        [32] call vgm_s_fnc_missions_startMission
*/

params ["_missionId"];

private _mission = [_missionId] call vgm_s_fnc_missions_getById;

if (isNil "_mission") exitWith {
    [format ["Cannot start mission %1 - mission does not exist", _missionId]] call vgm_g_fnc_logError;
    "MISSION_DOES_NOT_EXIST"
};

private _missionPublic = _mission get "public";

if (_missionPublic get "status" isNotEqualTo "CREATED") exitWith {
    ["Attempted to start a mission that has already started"] call vgm_g_fnc_logWarning;
    "MISSION_RUNNING"
};

private _startMissionCheckResults = [localNamespace, "vgm_s_missions_canStartMissionCheck", [_mission], true] call BIS_fnc_callScriptedEventHandler select { !isNil "_x" };
private _failureIndex = _startMissionCheckResults findIf { !isNil "_x" };

if (_failureIndex > -1) exitWith {
    private _failureCode = _startMissionCheckResults # _failureIndex;
    ["Failed to start mission: %1", _failureCode] call vgm_g_fnc_logWarning;
    _failureCode
};


[_mission, "IN PROGRESS"] call vgm_s_fnc_missions_updateStatus;
[_mission, "mission started", true] call vgm_s_fnc_missions_preventJoining;

[] remoteExecCall ["vgm_c_fnc_missions_startDeploy", values (_mission get "machineIds")];

[_missionPublic get "targetZone", 1] call vgm_s_fnc_missions_zones_spawnRandomSites;

[_mission] call vgm_s_fnc_director_startMission;
[_missionPublic get "startPosASL"] call vgm_s_fnc_missions_gameplay_ambient_departHelicopter; // TODO by what and where should this be fired?

/*
// Synced local objects example
[_mission] call {
    params ["_mission"];
    private _missionPublic = _mission get "public";
    private _pos = _missionPublic get "startPosASL";

    // full example of object creation
    // objects created before mission start event will be automatically spawned
    [_mission, ["vn_b_ammobox_01", ASLToAGL _pos, random 360, {
        params ["_object", "_params"];
        _object addAction ["Test action", {
            params ["", "_caller", "", "_arguments"];
            hint format ["I'm a box, hello %1 with params %2!", name _caller, _arguments];
        }, _params];

        _object addAction ["Delete me", {
            params ["_object"];
            private _objectId = _object getVariable "vgm_mission_objects_id";
            private _missionId = [] call vgm_c_fnc_missions_getCurrentMission get "id";

            [_missionId, _objectId] remoteExecCall ["vgm_s_fnc_mission_objects_deleteObject", 2];
        }];
    }, "test"]] call vgm_s_fnc_mission_objects_createObject;

    // example of spawning objects during the mission
    _mission spawn {
        sleep 5;
        params ["_mission"];
        private _missionPublic = _mission get "public";
        private _pos = _missionPublic get "startPosASL";

        private _objectIds = [];
        _objectIds pushBack ([_mission, ["vn_b_ammobox_02", ASLToAGL (_pos vectorAdd [0,2,0])]] call vgm_s_fnc_mission_objects_createObject);
        [_mission, _objectIds] call vgm_s_fnc_mission_objects_spawnObjects;
    };
};
*/

// TODO
// - Setup extract mechanics
// - Mark target box as occupied? Or is this a mission selection thing?

[] remoteExecCall ["vgm_c_fnc_missions_finishDeploy", values (_mission get "machineIds")];

[
    "vgm_mission_started",
    [_missionPublic get "id"]
] call para_g_fnc_event_triggerGlobal;

nil
