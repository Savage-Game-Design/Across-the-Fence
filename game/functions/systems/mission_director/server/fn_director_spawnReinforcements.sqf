/*
    File: fn_director_spawnReinforcements.sqf
    Author: Savage Game Design
    Date: 2024-11-02
    Last Update: 2025-10-29
    Public: Yes

    Description:
        Spawn enemy reinforcements to attack an engaged player.

    Parameter(s):
        _mission - Mission the player is on [HASHMAP]
        _players - Players to attack with the reinforcements [OBJECT]
        _reinforcementType - Type of unit to spawn (OPFOR or ZOMBIES) [STRING]

    Returns:
        The squad created, or nil if a squad couldn't be spawned. [GROUP]

    Example(s):
        [_mission, _players] call vgm_s_fnc_director_spawnReinforcements;
 */


params ["_mission", "_players", ["_reinforcementType", "OPFOR"]];

private _missionPublic = _mission get "public";
private _missionId = _missionPublic get "id";
private _spawnPos = [];
private _attackPos = getPosATL selectRandom _players;

for "_i" from 1 to 3 do {
    _spawnPos = ([_attackPos, playableUnits, random 360, 150, 400] call para_g_fnc_spawning_find_valid_position_tracer) # 0;
    if (_spawnPos isNotEqualTo []) exitWith {};
};

if (_spawnPos isEqualTo []) exitWith { nil };

private _director = _mission get "director";

// Based on player count and alertness
private _missionPlayers = (_missionPublic get "players") call para_g_fnc_netmap_count;
private _alertness = _director get "alertness";

// Scale with mission player count, not target player count (_players).
// This is to make it more punishing going solo in a group setting.
private _baseUnits = if (_reinforcementType isEqualTo "ZOMBIES") then {
    linearConversion [0, 90, _alertness, 4, 6, true]
} else {
    linearConversion [0, 90, _alertness, 2, 6, true]
};

private _playerCountScaling = if (_reinforcementType isEqualTo "ZOMBIES") then {
    linearConversion [1, 6, _missionPlayers, 1, 3]
} else {
    linearConversion [1, 6, _missionPlayers, 1, 4]
};

private _unitQuantity = floor (_baseUnits * _playerCountScaling);
private _unitsRemaining = _unitQuantity;

[format ["[Reinforcements - Mission: %1, Players: %2] Reinforcing with %3 %6 units (%4 base, %5x player scaling)",
    _missionId, _players, _unitQuantity, _baseUnits, _playerCountScaling, _reinforcementType
]] call vgm_g_fnc_logDebug;

private _squads = [];
private _minSquadSize = 3;
private _maxSquadSize = 6;
private _squadSizeVariation = _maxSquadSize - _minSquadSize;
while {_unitsRemaining > 0} do {
    private _template = if (_reinforcementType isEqualTo "ZOMBIES") then {
        private _zombieClass = (selectRandom vgm_s_director_attack_classes) + (selectRandomWeighted vgm_s_director_reinforcementZombieWeightings);
        private _newTemplate = [[_zombieClass], _spawnPos, _missionId] call vgm_s_fnc_director_getZombieSquadTemplate;
        _newTemplate set ["deleteOnDespawn", true];
        _newTemplate get "groupVars" set ["vgm_l_zombie_goToPosInitial", [_attackPos, true]];
        _newTemplate
    } else {
        // Spawns X units, + Y extra units, where Y is between 1 and 3, but Y is always less than or equal to _unitsRemaining
        private _squadSize = _minSquadSize + (( 1 + floor random _squadSizeVariation) min (_unitsRemaining - _minSquadSize) max 0);

        private _newTemplate = [vgm_s_director_attack_classes select [0, _squadSize], _spawnPos, _missionId] call vgm_s_fnc_director_getEnemySquadTemplate;
        _newTemplate set ["deleteOnDespawn", true];
        _newTemplate get "groupVars" set ["vgm_g_order", [
            createHashMapFromArray [
                ["type", "ASSAULT"],
                ["pos", _attackPos]
            ]
        ]];
        _newTemplate
    };

    private _squadSize = count (_template get "composition");

    _unitsRemaining = _unitsRemaining - _squadSize;

    [format ["[Reinforcements - Mission: %1, Players: %2] Creating reinforcement %5 squad (%3 units, %4 remaining)",
        _missionId, _players, _squadSize, _unitsRemaining, _reinforcementType
    ]] call vgm_g_fnc_logDebug;

    _squads pushBack ([_template] call vgm_s_fnc_virtsquad_create);
};

_squads
