/*
    File: fn_mission_objects_call.sqf
    Author: Savage Game Design
    Date: 2024-12-16
    Last Update: 2025-08-23
    Public: No

    Description:
        Propagate code execution on local mission objects to all machines participating in the mission.

    Parameter(s):
        _mission - Mission data [HASHMAP]
        _objectIds - Ids of the objects to execute code on [ARRAY]
        _fnc_callback - Code to execute, where objects are local [CODE]

    Returns:
        Something [BOOL]

    Example(s):
        [1, "objectId123", {hint str _this}] call vgm_s_fnc_mission_objects_call
 */

params [
    "_mission",
    "_objectIds",
    ["_fnc_callback", [[], {}], [[], {}], 2]
];

private _missionId = _mission get "public" get "id";

format ["Sending call for %1 objects in %2", count _objectIds, _missionId] call vgm_g_fnc_logInfo;

// spawn on all clients in mission and server
private _machines = values (_mission get "machineIds") + [2];
[_missionId, _objectIds, _fnc_callback] remoteExecCall ["vgm_g_fnc_mission_objects_call", _machines];
