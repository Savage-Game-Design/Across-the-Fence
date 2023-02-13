/*
    File: fn_respawn_onPlayerRespawn.sqf
    Author: Savage Game Design, Xorberax
    Public: Yes

    Description:
        Handles the player respawn behavior.

    Parameter(s):
        _newUnit [OBJECT]
        _oldUnit [OBJECT]
        _respawnType [NUMBER]
        _respawnDelay [NUMBER]

    Returns:
        NONE

    Example(s):
        See `CfgRespawnTemplates/vgm_respawn`.
*/

params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];

_safeSpawnTransform = [_newUnit, 300, 500, 100] call vgm_s_fnc_respawn_findSafeSpawnTransformNearTeam;
_newUnit setPosASL _safeSpawnTransform#0;
_newUnit setDir _safeSpawnTransform#1;

sleep 3;
[1, "WHITE", 3, 1] spawn BIS_fnc_fadeEffect;
