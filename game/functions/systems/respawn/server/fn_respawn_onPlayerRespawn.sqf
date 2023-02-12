/*
    File: fn_respawn_onPlayerRespawn.sqf
    Author: Savage Game Design, Xorberax
    Public: Yes

    Description:
        Handles player respawn behavior.

    Parameter(s):
        _newUnit: Object
        _oldUnit: Object
        _respawnType: Number
        _respawnDelay: Number

    Returns:
        NONE

    Example(s):
        See `CfgRespawnTemplates/vgm_respawn`.
*/

params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];

_safeSpawnTransform = [_newUnit, 100, 200, 100] call vgm_s_fnc_respawn_findSafeSpawnTransformNearTeam;
_newUnit setPosASL _safeSpawnTransform#0;
_newUnit setDir _safeSpawnTransform#1;
