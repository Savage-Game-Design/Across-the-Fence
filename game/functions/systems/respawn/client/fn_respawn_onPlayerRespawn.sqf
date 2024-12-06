/*
    File: fn_respawn_onPlayerRespawn.sqf
    Author: Savage Game Design, Xorberax
    Public: No

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

_safeSpawnTransform = [_newUnit, 300, 500, 100] call vgm_g_fnc_respawn_findSafeSpawnTransformNearTeam;
_newUnit setPosASL _safeSpawnTransform#0;
_newUnit setDir _safeSpawnTransform#1;

_newUnit setUnitLoadout (_newUnit getVariable ["vgm_respawn_loadout", getUnitLoadout typeOf _newUnit]);
deleteVehicle _oldUnit;

if (!isNil {[] call vgm_c_fnc_missions_getCurrentMission}) then {
    _newUnit call vgm_c_fnc_respawn_decayInventory;
};

sleep 3;
[1, "WHITE", 3, 1] spawn BIS_fnc_fadeEffect;

["vgm_player_respawn", [], [_newUnit]] call para_g_fnc_event_triggerTargets;
