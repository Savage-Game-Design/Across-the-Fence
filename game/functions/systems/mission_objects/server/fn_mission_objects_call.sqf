/*
    File: fn_mission_objects_call.sqf
    Author: Savage Game Design
    Date: 2024-12-16
    Last Update: 2024-12-16
    Public: No

    Description:
        Execute given code on local instances of the objects.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_s_fnc_mission_objects_call
 */

params [
    "_mission",
    "_objectIds",
    ["_fnc_callback", {}, [{}]]
];

private _missionId = _mission get "public" get "id";

format ["Sending call for %1 objects in %2", count _objectIds, _missionId] call vgm_g_fnc_logInfo;

// spawn on all clients in mission and server
private _machines = values (_mission get "machineIds") + [2];
[_missionId, _objectIds, _fnc_callback] remoteExecCall ["vgm_g_fnc_mission_objects_call", _machines];
