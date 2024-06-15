/*
    File: fn_missions_remoteExec_createMission.sqf
    Author: Savage Game Design
    Date: 2023-03-05
    Last Update: 2024-04-04
    Public: Yes

    Description:
        remoteExec version of fnc_missions_createMission.

    Parameter(s):
        _playerId - Direct Player ID of player that initiated the remoteExec [UNIT]

    Returns:
        Nothing

    Example(s):
        [getPlayerID player, "vgm_targetBox_1"] remoteExec ["vgm_s_fnc_missions_remoteExec_createMission", 2];
 */

params ["_playerId", "_targetZone"];

if !([_playerId] call para_s_fnc_remoteExec_validateDirectPlayIdIsRemoteExecOwner) exitWith {};

if (!([_playerId, _targetZone] call vgm_s_fnc_missions_zones_reserveZone)) exitWith {
    ["vgm_mission_creationFailed", [_targetZone], [remoteExecutedOwner]] call para_g_fnc_event_triggerTargets;
};

[
    createHashMap,
    _playerId,
    _targetZone
] call vgm_s_fnc_missions_createMission;
