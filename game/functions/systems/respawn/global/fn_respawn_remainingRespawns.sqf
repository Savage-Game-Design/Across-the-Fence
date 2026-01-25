/*
    File: fn_respawn_remainingRespawns.sqf
    Author: Savage Game Design
    Date: 2025-03-01
    Last Update: 2026-01-05
    Public: Yes

    Description:
        Returns the number of respawns still available to the player.

    Parameter(s):
        _player - Player to check [UNIT]

    Returns:
        Number of respawns remaining [NUMBER]

    Example(s):
        [player] call vgm_g_fnc_respawn_remainingRespawns;
 */

params [["_player", player]];

// We count *up* on respawns, so we can dynamically adjust the respawns the player is allowed during the mission
// e.g due to skills or being in singleplayer.
private _respawnsUsed = _player getVariable ["vgm_g_respawn_respawnsUsed", 0];

private _bonusRespawns = [_player, "respawn_bonusLives"] call vgm_c_fnc_coefficient_get;
private _remainingRespawns = (vgm_g_respawn_maximumRespawns + _bonusRespawns - _respawnsUsed) max 0;

// Players not on a mission should have unlimited respawns
if ([getPlayerID _player] call vgm_g_fnc_missions_getAssignedMissionId < 0) exitWith {
    vgm_g_respawn_maximumRespawns
};

_remainingRespawns
