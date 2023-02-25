/*
    File: fn_missions_remoteExec_startMission.sqf
    Author: Savage Game Design
    Date: 2023-03-05
    Last Update: 2023-04-24
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

private _missionsData = localNamespace getVariable "vgm_missions_data";

private _mission = _missionsData get "currentMissionAssignments" get _playerId;

if (isNil "_mission") exitWith {
    [format ["Cannot start mission for player %1 when player has no current mission", _playerId]] call vgm_g_fnc_logError;
};

private _missionCreator = _mission get "creator";
if !(_missionCreator isEqualTo "" || _missionCreator isEqualTo _playerId) exitWith {
    [format ["Player %1 cannot start mission %2 as they are not the leader.", _playerId, _mission get "id"]] call vgm_g_fnc_logWarning;
};

[
    _mission get "id"
] call vgm_s_fnc_missions_startMission;
