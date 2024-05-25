/*
    File: fn_missions_setPlayerReadiness.sqf
    Author:
    Date: 2023-02-26
    Last Update: 2023-09-20
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

private _missions = localNamespace getVariable "vgm_missions";
private _missionId = (["vgm_mission_assignments"] call para_g_fnc_netmap_get) get _playerId;

if (isNil "_missionId") exitWith {
    [format ["Unable to set readiness of player %1 to %2, no mission assigned", _playerId, _isReady]] call vgm_g_fnc_logError;
};

// No risk of nil value - if player is in currentMissionAssignments, this *should* be guaranteed.
private _mission = _missions get _missionId;
[_mission get "public" get "players" get _playerId, "ready", _isReady] call para_s_fnc_netmap_set;

[
    "vgm_mission_player_readiness_changed",
    [_playerId, _isReady, _mission get "public" get "id"]
] call para_g_fnc_event_triggerGlobal;

_isReady
