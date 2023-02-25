/*
    File: fn_missions_removePlayerFromMission.sqf
    Author: Savage Game Design
    Date: 2023-03-20
    Last Update: 2023-06-20
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

private _missionsData = localNamespace getVariable "vgm_missions_data";
private _currentMissionAssignments = _missionsData get "currentMissionAssignments";

private _playerCurrentMission = _currentMissionAssignments get _playerId;

if (!isNil "_playerCurrentMission" && {(_playerCurrentMission get "id") isEqualTo (_mission get "id")}) then {
    _currentMissionAssignments deleteAt _playerId;
};

private _playerMachineId = _mission get "machineIds" get _playerId;

_mission get "players" deleteAt _playerId;
_mission get "machineIds" deleteAt _playerId;

[_mission] call vgm_s_fnc_missions_updateMissionDataOnClients;

[nil] remoteExecCall ["vgm_c_fnc_missions_setCurrentMission", _playerMachineId];

[
    "player removed from mission",
    [_playerId, _mission]
] call para_g_fnc_event_triggerGlobal;

// Mission can never be full if someone just left.
[_mission, "mission full", false] call vgm_s_fnc_missions_preventJoining;

true
