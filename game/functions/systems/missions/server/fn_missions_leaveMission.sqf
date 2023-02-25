/*
    File: fn_missions_leaveMission.sqf
    Author: Savage Game Design
    Date: 2023-02-25
    Last Update: 2023-04-24
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

private _missionsData = localNamespace getVariable "vgm_missions_data";
private _currentMissionAssignments = _missionsData get "currentMissionAssignments";

if (
    !(_playerId in _currentMissionAssignments)
) exitWith { false };

private _mission = _currentMissionAssignments get _playerId;

private _removeSuccessful = [_playerId, _mission] call vgm_s_fnc_missions_removePlayerFromMission;

if (!_removeSuccessful) exitWith {
    [format ["Unable to remove player %1 from mission %2", _playerId, _mission get "id"]] call vgm_g_fnc_logWarning;
    false
};

// TODO - How to handle the last player leaving the mission?

true
