/*
    File: fn_missions_setPlayerReadiness.sqf
    Author:
    Date: 2023-02-26
    Last Update: 2023-04-23
    Public: Yes

    Description:
        Sets a player as ready or not to deploy on the mission

    Parameter(s):
        _playerId - DirectPlayID of the player to mark as ready [STRING]
        _isReady - Status to set the readiness to (yes ready/no not ready) [BOOL]

    Returns:
        Player ready status [BOOL]

    Example(s):
        [getPlayerId _player, true] call vgm_s_fnc_missions_setPlayerReadiness
 */

params ["_playerId", "_isReady"];

private _missionsData = localNamespace getVariable "vgm_missions_data";

private _mission = _missionsData get "currentMissionAssignments" get _playerId;

if (isNil "_mission") exitWith {
    [format ["Unable to set readiness of player %1 to %2, no mission assigned", _playerId, _isReady]] call vgm_g_fnc_logError;
};

// No risk of nil value - if player is in currentMissionAssignments, this should be guaranteed.
private _missionPlayerData = _mission get "players" get _playerId;
_missionPlayerData set ["ready", _isReady];

[_mission] call vgm_s_fnc_missions_updateMissionDataOnClients;

[
    "mission player readiness changed",
    [_playerId, _isReady]
] call para_g_fnc_event_triggerGlobal;

_isReady
