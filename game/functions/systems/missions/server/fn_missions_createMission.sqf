/*
    File: fn_missions_createMission.sqf
    Author: Savage Game Design
    Date: 2023-02-25
    Last Update: 2023-06-20
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

params ["_parameters", ["_creatorId", ""]];

private _missionsData = localNamespace getVariable "vgm_missions_data";

// This method of creating IDs assumes missions aren't persistent across restarts/servers
private _lastMissionId = _missionsData getOrDefault ["last_mission_id_created", 0];
private _newMissionId = _lastMissionId + 1;
_missionsData set ["last_mission_id_created", _newMissionId];

private _mission = createHashMapFromArray [
    ["id", _newMissionId],
    // Copy the parameters hashmap to prevent it being accidentally modified elsewhere.
    ["parameters", +_parameters],
    ["creator", _creatorId],
    ["status", "CREATED"],
    ["maxPlayers", 6],
    ["players", createHashMap],
    // Maps player ID to their client ID for easy remoteExec'ing
    ["machineIds", createHashMap],
    // Whether or not players can join the mission. Players can join if no values are "false"
    ["prevent joining", createHashMap],
    // TODO - Use an actual position for the mission
    ["startPosASL", AGLtoASL getMarkerPos "vgm_test_mission_start_pos"]
];

_missionsData get "missions" set [_newMissionId, _mission];

[_mission] call vgm_s_fnc_missions_updateMissionDataOnClients;

[
    "missions available",
    [[_mission get "id"]]
] call para_g_fnc_event_triggerGlobal;

[
    "mission joinable",
    [_mission get "id"]
] call para_g_fnc_event_triggerGlobal;

if !(_creatorId isEqualTo "") then {
    // Use this instead of fn_missions_joinMission to prevent two updates on the client.
    [_creatorId, _mission] call vgm_s_fnc_missions_attachPlayerToMission;
};

_mission

