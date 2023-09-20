/*
    File: fn_missions_createMission.sqf
    Author: Savage Game Design
    Date: 2023-02-25
    Last Update: 2023-09-20
    Public: Yes

    Description:
        Creates a new mission with the provided parameters

    Parameter(s):
        _parameters - The parameters for the mission [HASHMAP]
        _creatorId - Player ID of player creating the mission, defaults to "" [STRING]

    Returns:
        Mission [HASHMAP]

    Example(s):
        [
            createHashMapFromArray [
                ["difficulty", "HARD"]
            ]
        ] call vgm_s_fnc_missions_createMission;
 */

params [
    ["_parameters", nil, [createHashMap]],
    ["_creatorId", "", [""]]
];

// This method of creating IDs assumes missions aren't persistent across restarts/servers
private _lastMissionId = localNamespace getVariable ["vgm_last_mission_id_created", 0];
private _newMissionId = _lastMissionId + 1;
localNamespace setVariable ["vgm_last_mission_id_created", _newMissionId];

private _mission = createHashMapFromArray [
    // Public variables, available over the network
    ["public", [[
        ["id", _newMissionId],
        ["creator", _creatorId],
        ["status", "CREATED"],
        ["maxPlayers", 6],
        // Each player on the mission should have a netmap in here for storing player data
        ["players", [] call para_s_fnc_netmap_createNetmap],
        // Maps player ID to their client ID for easy remoteExec'ing
        ["machineIds", createHashMap],
        // Whether or not players can join the mission. Players can join if no values are "false"
        ["preventJoining", [] call para_s_fnc_netmap_createNetmap],
        // TODO - Use an actual position for the mission
        ["startPosASL", AGLtoASL getMarkerPos "vgm_test_mission_start_pos"],
        ["group", createGroup side vgm_core_lobbyGroup]
    ]] call para_s_fnc_netmap_createNetmapFromArray],
    // Copy the parameters hashmap to prevent it being accidentally modified elsewhere.
    ["parameters", +_parameters],
    // Maps player ID to their client ID for easy remoteExec'ing
    ["machineIds", createHashMap]
];

// Register the mission on the server.
private _missions = localNamespace getVariable "vgm_missions";
_missions set [_newMissionId, _mission];

// Registers the mission's public variables in a netmap, so the client can access them.
private _missionsPublicInfo = ["vgm_missions_publicMissionInfo"] call para_g_fnc_netmap_get;
[_missionsPublicInfo, _newMissionId, _mission get "public"] call para_s_fnc_netmap_set;

[
    "vgm_mission_available",
    [[_mission get "public" get "id"]]
] call para_g_fnc_event_triggerGlobal;

[
    "vgm_mission_joinable",
    [_mission get "public" get "id"]
] call para_g_fnc_event_triggerGlobal;

if !(_creatorId isEqualTo "") then {
    // Use this instead of fn_missions_joinMission to prevent two updates on the client.
    [_creatorId, _mission] call vgm_s_fnc_missions_attachPlayerToMission;
};

_mission

