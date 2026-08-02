/*
    File: fn_respawn_remainingRespawns.sqf
    Author: Savage Game Design
    Date: 2025-03-01
    Last Update: 2026-03-05
    Public: Yes

    Description:
        Returns the number of respawns still available to the player.
        Base: 1 respawn. +1 from "Not Dead Yet" perk. +1 if solo (group size 1).

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
_bonusRespawns = _bonusRespawns + (_player getVariable ["vgm_c_skill_notDeadYet_bonusRespawns", 0]);

// Solo bonus: +1 respawn if only one player is in the group.
private _soloBonus = if (count (units group _player select {isPlayer _x}) <= 1) then {1} else {0};

private _remainingRespawns = (vgm_g_respawn_maximumRespawns + _bonusRespawns + _soloBonus - _respawnsUsed) max 0;

// Players not on a mission should have unlimited respawns
if ([getPlayerID _player] call vgm_g_fnc_missions_getAssignedMissionId < 0) exitWith {
    vgm_g_respawn_maximumRespawns
};

_remainingRespawns
