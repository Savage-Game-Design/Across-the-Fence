/*
    File: fn_missions_updateMissionDataOnClients.sqf
    Author: Savage Game Design
    Date: 2023-04-23
    Last Update: 2023-04-23
    Public: No

    Description:
        Broadcasts updated mission data to all clients

    Parameter(s):
        _mission - Mission to send to all clients [HASHMAP]
        _clients - Clients to send the mission data to, defaults to all [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [_mission] call vgm_s_fnc_missions_updateMissionDataOnClients
 */

params ["_mission", ["_clients", 0]];

[
    _mission get "id",
    _mission
] remoteExecCall ["vgm_c_fnc_missions_updateMissionData", _clients];
