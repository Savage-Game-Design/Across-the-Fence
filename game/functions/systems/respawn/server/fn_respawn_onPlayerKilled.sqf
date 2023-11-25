/*
    File: fn_respawn_onPlayerKilled.sqf
    Author: Savage Game Design, Xorberax
    Public: No

    Description:
        Handles the player killed behavior.

    Parameter(s):
        _oldUnit [OBJECT]
        _killer [OBJECT]
        _respawnType [NUMBER]
        _respawnDelay [NUMBER]

    Returns:
        NONE

    Example(s):
        See `CfgRespawnTemplates/vgm_respawn`.
*/

params ["_oldUnit", "_killer", "_respawnType", "_respawnDelay"];

_oldUnit setVariable ["vgm_respawn_loadout", getUnitLoadout _oldUnit];

sleep 1;
[0, "WHITE", 3, 1] spawn BIS_fnc_fadeEffect;
