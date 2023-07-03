/*
    File: fn_missions_remoteExec_joinMission.sqf
    Author: Savage Game Design
    Date: 2023-03-05
    Last Update: 2023-04-23
    Public: Yes

    Description:
        remoteExec version of fnc_missions_joinMission.

    Parameter(s):
        _playerId - Direct Player ID of player that initiated the remoteExec [UNIT]
        _missionId - ID of the mission to join [NUMBER]

    Returns:
        Nothing

    Example(s):
        [getPlayerID player, _missionId] remoteExec ["vgm_s_fnc_missions_remoteExec_joinMission", 2];
 */

params ["_playerId", "_missionId"];

if !([_playerId] call para_s_fnc_remoteExec_validateDirectPlayIdIsRemoteExecOwner) exitWith {};

[
    _playerId,
    _missionId
] call vgm_s_fnc_missions_joinMission;
