/*
    File: fn_missions_remoteExec_setReadiness.sqf
    Author: Savage Game Design
    Date: 2023-03-05
    Last Update: 2023-04-23
    Public: Yes

    Description:
        remoteExec version of fnc_missions_setPlayerReadiness.

    Parameter(s):
        _playerId - Direct Player ID of player that initiated the remoteExec [UNIT]
        _isReady - Status to set the readiness to (yes ready/no not ready) [BOOL]

    Returns:
        Nothing

    Example(s):
        [getPlayerID player, true] remoteExec ["vgm_s_fnc_missions_remoteExec_setPlayerReadiness", 2];
 */

params ["_playerId", "_isReady"];

if !([_playerId] call para_s_fnc_remoteExec_validateDirectPlayIdIsRemoteExecOwner) exitWith {};

[
    _playerId,
    _isReady
] call vgm_s_fnc_missions_setPlayerReadiness;
