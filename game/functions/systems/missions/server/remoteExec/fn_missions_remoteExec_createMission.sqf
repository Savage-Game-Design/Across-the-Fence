/*
    File: fn_missions_remoteExec_createMission.sqf
    Author: Savage Game Design
    Date: 2023-03-05
    Last Update: 2025-10-29
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

if (isNil "_targetZone") then {
    _targetZone = selectRandom ([] call vgm_g_fnc_missions_zones_getUnreservedZones);
};

if (!([_playerId, _targetZone] call vgm_s_fnc_missions_zones_reserveZone)) exitWith {
    ["vgm_mission_creationFailed", ["ZONE_RESERVATION_FAILED", [_targetZone]], [remoteExecutedOwner]] call para_g_fnc_event_triggerTargets;
};

[
    createHashMap,
    _playerId,
    _targetZone
] call vgm_s_fnc_missions_createMission;
