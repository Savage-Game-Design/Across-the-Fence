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

#define RALLY_POINT_MAX_DISTANCE 400
#define RALLY_POINT_MAX_SPAWN_DISTANCE 150

params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];

_newUnit setVariable ["vgm_g_respawn_respawnsUsed", (_newUnit getVariable ["vgm_g_respawn_respawnsUsed", 0]) + 1, true];

private _safeSpawnTransform = [] call vgm_g_fnc_missions_getHubSpawnPos;

private _mission = [] call vgm_c_fnc_missions_getCurrentMission;

if (!isNil "_mission") then {
    private _rallyPosATL = _mission get "system_respawn" getOrDefault ["rallyPosATL", [-1e10, -1e10]];
    if (_rallyPosATL distance2D _oldUnit < RALLY_POINT_MAX_DISTANCE) exitWith {
        _safeSpawnTransform = [_rallyPosATL, 0, RALLY_POINT_MAX_SPAWN_DISTANCE] call vgm_g_fnc_respawn_findSafeSpawnTransform;
    };

    _safeSpawnTransform = [_newUnit] call vgm_g_fnc_respawn_findSafeSpawnTransformNearTeam;
};

hint str [getPosATL player, _safeSpawnTransform];
_newUnit setPosASL _safeSpawnTransform#0;
_newUnit setDir _safeSpawnTransform#1;

_newUnit setUnitLoadout (_newUnit getVariable ["vgm_respawn_loadout", getUnitLoadout typeOf _newUnit]);
deleteVehicle _oldUnit;

if (!isNil {[] call vgm_c_fnc_missions_getCurrentMission}) then {
    private _lostItems = _newUnit call vgm_c_fnc_respawn_decayInventory;
    [_lostItems] spawn vgm_c_fnc_respawn_showRespawnInfo;
};

sleep 4;
[1, "WHITE", 3, 1] spawn BIS_fnc_fadeEffect;

["vgm_player_respawn", [], [_newUnit]] call para_g_fnc_event_triggerTargets;
