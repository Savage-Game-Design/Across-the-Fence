/*
    File: fn_missions_attachPlayerToMission.sqf
    Author: Savage Game Design
    Date: 2023-03-17
    Last Update: 2025-02-03
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

private _currentMissionAssignments = ["vgm_mission_assignments"] call para_g_fnc_netmap_get;
private _missionPublic = _mission get "public";

if (
    // Player must not be assigned to a mission already
    _playerId in _currentMissionAssignments
    // PlayerId must be a valid user
    || getUserInfo _playerId isEqualTo []
    // Mission must not be at max players
    || (_missionPublic get "players" call para_g_fnc_netmap_count) >= (_missionPublic get "maxPlayers")
    // Mission can't have already started when a player is joining
    || _missionPublic get "status" isNotEqualTo "CREATED"
) exitWith { false };

[_currentMissionAssignments, _playerId, _missionPublic get "id"] call para_s_fnc_netmap_set;

private _playerInfoNetmap = [] call para_s_fnc_netmap_createNetmap;
[_playerInfoNetmap, _missionPublic get "players"] call para_s_fnc_netmap_setOwningNetmap;

[
    _missionPublic get "players",
    _playerId,
    _playerInfoNetmap
] call para_s_fnc_netmap_set;

(_mission get "machineIds") set [_playerId, getUserInfo _playerId select 1];

if (isNull (_missionPublic get "group")) then {
    [_missionPublic, "group", createGroup side vgm_core_lobbyGroup] call para_s_fnc_netmap_set;
};

// joinSilent seems to sometimes mysteriously fail. RemoteExec'ing is an attempt to solve that.
private _playerUnit = _playerId call vgm_s_fnc_player_fromId;
[_playerUnit, _missionPublic get "group"] remoteExec ["joinSilent", _playerUnit];

[
    "vgm_mission_attached",
    [_playerId, _missionPublic get "id"]
] call para_g_fnc_event_triggerGlobal;

private _missionIsFull = ((_missionPublic get "players") call para_g_fnc_netmap_count) >= _missionPublic get "maxPlayers";
[_mission, "mission full", _missionIsFull] call vgm_s_fnc_missions_preventJoining;

true
