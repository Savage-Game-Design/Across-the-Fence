/*
    File: fn_missions_leaveMission.sqf
    Author: Savage Game Design
    Date: 2023-02-25
    Last Update: 2023-06-22
    Public: Yes

    Description:
        Unassigns a player from their current mission.

    Parameter(s):
        _playerId - DirectPlay id of player to remove from their current mission [STRING]

    Returns:
        Whether or not the leave was successful [BOOLEAN]

    Example(s):
        [getPlayerId player] remoteExecCall ["vgm_s_fnc_missions_leaveMission", 2]
 */

params ["_playerId"];

private _missions = localNamespace getVariable "vgm_missions";
private _currentMissionAssignments = ["vgm_mission_assignments"] call para_g_fnc_netmap_get;

if (
    !(_playerId in _currentMissionAssignments)
) exitWith { false };

private _missionId = _currentMissionAssignments get _playerId;
private _mission = _missions get _missionId;

private _removeSuccessful = [_playerId, _mission] call vgm_s_fnc_missions_removePlayerFromMission;

if (!_removeSuccessful) exitWith {
    [format ["Unable to remove player %1 from mission %2", _playerId, _missionId]] call vgm_g_fnc_logWarning;
    false
};

// TODO - How to handle the last player leaving the mission?

true
