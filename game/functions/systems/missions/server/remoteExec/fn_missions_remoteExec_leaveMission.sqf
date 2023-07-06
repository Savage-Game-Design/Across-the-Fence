/*
    File: fn_missions_remoteExec_leaveMission.sqf
    Author: Savage Game Design
    Date: 2023-03-05
    Last Update: 2023-06-20
    Public: Yes

    Description:
        remoteExec version of fnc_missions_leaveMission.

    Parameter(s):
        _playerId - Direct Player ID of player that initiated the remoteExec [UNIT]

    Returns:
        Nothing

    Example(s):
        [getPlayerID player] remoteExec ["vgm_s_fnc_missions_remoteExec_leaveMission", 2];
 */

params ["_playerId"];

if !([_playerId] call para_s_fnc_remoteExec_validateDirectPlayIdIsRemoteExecOwner) exitWith {};

[
    _playerId
] call vgm_s_fnc_missions_leaveMission;
