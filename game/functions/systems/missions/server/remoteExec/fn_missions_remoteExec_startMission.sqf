/*
    File: fn_missions_remoteExec_startMission.sqf
    Author: Savage Game Design
    Date: 2023-03-05
    Last Update: 2025-11-13
    Public: Yes

    Description:
        remoteExec version of fnc_missions_startMission.
        Starts the mission the player is currently assigned to.

    Parameter(s):
        _playerId - Direct Player ID of player that initiated the remoteExec [UNIT]

    Returns:
        Nothing

    Example(s):
        [getPlayerID player] remoteExec ["vgm_s_fnc_missions_remoteExec_startMission", 2];
 */

params ["_playerId"];

if !([_playerId] call para_s_fnc_remoteExec_validateDirectPlayIdIsRemoteExecOwner) exitWith {};

private _missions = localNamespace getVariable "vgm_missions";
private _currentMissionAssignments = ["vgm_mission_assignments"] call para_g_fnc_netmap_get;

if !(_playerId in _currentMissionAssignments) exitWith {
    [format ["Cannot start mission for player %1 when player has no current mission", _playerId]] call vgm_g_fnc_logError;
};

private _missionId = _currentMissionAssignments get _playerId;
private _mission = _missions get _missionId;

private _missionCreator = _mission get "public" get "creator";
if !(_missionCreator isEqualTo "" || _missionCreator isEqualTo _playerId) exitWith {
    [format ["Player %1 cannot start mission %2 as they are not the leader.", _playerId, _mission get "id"]] call vgm_g_fnc_logWarning;
};

private _missionStartFailureCode = [_mission get "public" get "id"] call vgm_s_fnc_missions_startMission;

if (!isNil "_missionStartFailureCode") exitWith {
    createHashMapFromArray [
        ["title", "STR_VGM_MISSIONS_START_FAILED"],
        ["body", format ["STR_VGM_MISSIONS_START_FAILED_CODE_%1", _missionStartFailureCode]]
    ] remoteExec ["vgm_c_fnc_postNotification", _mission get "machineIds" get _playerId];
};
