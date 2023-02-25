/*
    File: fn_missions_remoteExec_requestMissionData.sqf
    Author: Savage Game Design
    Date: 2023-03-05
    Last Update: 2023-04-23
    Public: Yes

    Description:
        remoteExec version of fnc_missions_requestMissionData.
        Starts the mission the player is currently assigned to.

    Parameter(s):
        _playerId - Direct Player ID of player that initiated the remoteExec [UNIT]

    Returns:
        Nothing

    Example(s):
        [getPlayerID player] remoteExecCall ["vgm_s_fnc_missions_remoteExec_requestMissionData", 2];
 */

params ["_playerId"];

if !([_playerId] call para_s_fnc_remoteExec_validateDirectPlayIdIsRemoteExecOwner) exitWith {};

private _missionsData = localNamespace getVariable "vgm_missions_data";
private _missions = _missionsData get "missions";
private _machineId = getUserInfo _playerId select 1;

{
    [_y, _machineId] call vgm_s_fnc_missions_updateMissionDataOnClients;
} forEach _missions;

[
    "missions available",
    [_missions apply {_x get "id"}],
    [_machineId]
] call para_g_fnc_event_triggerTargets;
