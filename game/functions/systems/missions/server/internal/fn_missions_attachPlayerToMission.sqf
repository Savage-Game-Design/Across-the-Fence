/*
    File: fn_missions_attachPlayerToMission.sqf
    Author: Savage Game Design
    Date: 2023-03-17
    Last Update: 2023-06-20
    Public: No

    Description:
        Assigns a player to the given mission.
        This is distinct from fnc_missions_joinMission as this might be used as part of other actions.
        e.g Creating a mission.

        As such, it doesn't perform many checks, or synchronise over the network.

    Parameter(s):
    	_playerId - DirectPlayID of the player to join to the mission [STRING]
        _mission - Mission to join the player to [HASHMAP]

    Returns:
        True if the player is now on the mission, false otherwise [BOOL]

    Example(s):
        ["321124123", _nextMission] call vgm_s_fnc_missions_attachPlayerToMission;
 */

params ["_playerId", "_mission"];

private _missionsData = localNamespace getVariable "vgm_missions_data";
private _currentMissionAssignments = _missionsData get "currentMissionAssignments";

if (
    // Player must not be assigned to a mission already
    _playerId in _currentMissionAssignments
    // PlayerId must be a valid user
    || getUserInfo _playerId isEqualTo []
    // Mission must not be at max players
    || count (_mission get "players") >= (_mission get "maxPlayers")
    // Mission can't have already started when a player is joining
    || _mission get "status" isNotEqualTo "CREATED"
) exitWith { false };

_currentMissionAssignments set [_playerId, _mission];
_mission get "players" set [_playerId, createHashMap];
_mission get "machineIds" set [_playerId, getUserInfo _playerId select 1];

// Update clients with result from attachPlayerToMission
[_mission] call vgm_s_fnc_missions_updateMissionDataOnClients;

[_mission get "id"] remoteExecCall ["vgm_c_fnc_missions_setCurrentMission", _mission get "machineIds" get _playerId];

[
    "player attached to mission",
    [_playerId, _mission]
] call para_g_fnc_event_triggerGlobal;

private _missionIsFull = count (_mission get "players") >= _mission get "maxPlayers";
[_mission, "mission full", _missionIsFull] call vgm_s_fnc_missions_preventJoining;

true
