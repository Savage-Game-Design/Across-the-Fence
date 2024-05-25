/*
    File: fn_missions_removePlayerFromMission.sqf
    Author: Savage Game Design
    Date: 2023-03-20
    Last Update: 2023-09-21
    Public: No

    Description:
        Removes a player from the given mission.
        This is distinct from fnc_missions_leaveMission as this might be used as part of other actions.
        e.g Deleting a mission.

        As such, it doesn't perform many checks, or synchronise over the network.

    Parameter(s):
    	_playerId - DirectPlayID of the player to remove from the mission [STRING]
        _mission - Mission to remove the player from [HASHMAP]

    Returns:
        True if player is no longer on the mission, false otherwise  [BOOL]

    Example(s):
        [_playerToRemove, _mission] call vgm_s_fnc_missions_removePlayerFromMission
 */

params ["_playerId", "_mission"];

private _missionPublic = _mission get "public";
private _currentMissionAssignments = ["vgm_mission_assignments"] call para_g_fnc_netmap_get;
private _playerCurrentMissionId = _currentMissionAssignments get _playerId;

if (isNil "_playerCurrentMissionId" || {_playerCurrentMissionId isNotEqualTo (_missionPublic get "id")}) exitWith {};

// Save machine ID so we can remoteExec things later
private _playerMachineId = _mission get "machineIds" get _playerId;

[_currentMissionAssignments, _playerId] call para_s_fnc_netmap_deleteAt;
[_missionPublic get "players", _playerId] call para_s_fnc_netmap_deleteAt;
_mission get "machineIds" deleteAt _playerId;

[_playerId call vgm_s_fnc_player_fromId] joinSilent vgm_core_lobbyGroup;

[
    "player removed from mission",
    [_playerId, _missionPublic get "id"]
] call para_g_fnc_event_triggerGlobal;

// Mission can never be full if someone just left.
[_mission, "mission full", false] call vgm_s_fnc_missions_preventJoining;

true
