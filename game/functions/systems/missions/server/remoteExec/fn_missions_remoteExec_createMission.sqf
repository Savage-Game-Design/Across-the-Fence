/*
    File: fn_missions_remoteExec_createMission.sqf
    Author: Savage Game Design
    Date: 2023-03-05
    Last Update: 2023-06-20
    Public: Yes

    Description:
        remoteExec version of fnc_missions_createMission.

    Parameter(s):
        _playerId - Direct Player ID of player that initiated the remoteExec [UNIT]

    Returns:
        Nothing

    Example(s):
        [getPlayerID player] remoteExec ["vgm_s_fnc_missions_remoteExec_createMission", 2];
 */

params ["_playerId"];

if !([_playerId] call para_s_fnc_remoteExec_validateDirectPlayIdIsRemoteExecOwner) exitWith {};

[
    createHashMap,
    _playerId
] call vgm_s_fnc_missions_createMission;
