/*
    File: fn_respawn_onPlayerRespawn.sqf
    Author: Savage Game Design, Xorberax
    Public: No

    Description:
        Handles the player respawn behavior.
        - No respawns remaining: enter spectator (end game camera).
        - Respawns available: spawn 300m max from alive squad members,
          or near death position if solo/all dead. Restore loadout minus
          rucksack (dropped at death location).

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

#define SQUAD_SPAWN_MIN_DISTANCE 100
#define SQUAD_SPAWN_MAX_DISTANCE 300

params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];

// Check remaining respawns BEFORE incrementing
private _remaining = [_newUnit] call vgm_g_fnc_respawn_remainingRespawns;

if (_remaining <= 0) exitWith {
    // No respawns left — enter spectator
    format ["Player has no remaining respawns — entering spectator"] call vgm_g_fnc_logInfo;

    // Hide the unit
    _newUnit enableSimulation false;
    _newUnit hideObjectGlobal true;

    // Spectator camera
    [true, player, true, true, true, true] call BIS_fnc_EGSpectator;

    ["vgm_player_respawn", [], [_newUnit]] call para_g_fnc_event_triggerTargets;
};

// Increment respawn counter
_newUnit setVariable ["vgm_g_respawn_respawnsUsed", (_newUnit getVariable ["vgm_g_respawn_respawnsUsed", 0]) + 1, true];

// --- Determine spawn location ---
private _deathPos = _oldUnit getVariable ["vgm_respawn_deathPos", getPosATL _oldUnit];
private _safeSpawnTransform = [];
private _mission = [] call vgm_c_fnc_missions_getCurrentMission;

if (!isNil "_mission") then {
    // Check for rally point first
    private _rallyPos = (_mission getOrDefault ["system_respawn", createHashMap]) getOrDefault ["rallyPosATL", []];

    if (_rallyPos isNotEqualTo []) then {
        // Rally point set — spawn within 10m of it
        _safeSpawnTransform = [_rallyPos, 0, 10] call vgm_g_fnc_respawn_findSafeSpawnTransform;
    } else {
        // No rally point — use squad or death position
        private _aliveSquadMates = (units group _newUnit) select {
            alive _x && isPlayer _x && _x != _newUnit
            && !(_x getVariable ["vn_revive_incapacitated", false])
        };

        if (_aliveSquadMates isNotEqualTo []) then {
            // Spawn near alive squad members (100-300m)
            _safeSpawnTransform = [_newUnit, SQUAD_SPAWN_MIN_DISTANCE, SQUAD_SPAWN_MAX_DISTANCE] call vgm_g_fnc_respawn_findSafeSpawnTransformNearTeam;
        } else {
            // No alive squad — spawn near death position
            _safeSpawnTransform = [_deathPos, 50, SQUAD_SPAWN_MAX_DISTANCE] call vgm_g_fnc_respawn_findSafeSpawnTransform;
        };
    };
};

// Fallback to hub if no mission or spawn transform failed
if (_safeSpawnTransform isEqualTo [] || {isNil "_safeSpawnTransform"}) then {
    _safeSpawnTransform = [] call vgm_g_fnc_missions_getHubSpawnPos;
};

_newUnit setPosASL _safeSpawnTransform#0;
_newUnit setDir _safeSpawnTransform#1;

// Restore loadout then strip backpack (it was dropped at death location)
_newUnit setUnitLoadout (_newUnit getVariable ["vgm_respawn_loadout", getUnitLoadout typeOf _newUnit]);
deleteVehicle _oldUnit;

// Remove rucksack and show what was lost
if (!isNil {[] call vgm_c_fnc_missions_getCurrentMission}) then {
    private _lostItems = _newUnit call vgm_c_fnc_respawn_decayInventory;
    [_lostItems] spawn vgm_c_fnc_respawn_showRespawnInfo;
};

sleep 4;
[1, "WHITE", 3, 1] spawn BIS_fnc_fadeEffect;

["vgm_player_respawn", [], [_newUnit]] call para_g_fnc_event_triggerTargets;
