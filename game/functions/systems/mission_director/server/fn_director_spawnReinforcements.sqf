/*
    File: fn_director_spawnReinforcements.sqf
    Author: Savage Game Design
    Date: 2024-11-02
    Last Update: 2025-09-19
    Public: Yes

    Description:
        Spawn enemy reinforcements to attack an engaged player.

    Parameter(s):
        _mission - Mission the player is on [HASHMAP]
        _players - Players to attack with the reinforcements [OBJECT]

    Returns:
        The squad created, or nil if a squad couldn't be spawned. [GROUP]

    Example(s):
        [_mission, _players] call vgm_s_fnc_director_spawnReinforcements;
 */


params ["_mission", "_players"];

private _missionPublic = _mission get "public";
private _missionId = _missionPublic get "id";
private _spawnPos = [];
private _attackPos = getPosATL selectRandom _players;

for "_i" from 1 to 3 do {
    _spawnPos = ([_attackPos, playableUnits, random 360, 150, 400] call para_g_fnc_spawning_find_valid_position_tracer) # 0;
    if (_spawnPos isNotEqualTo []) exitWith {};
};

if (_spawnPos isEqualTo []) exitWith { nil };

// Based on player count and alertness
private _missionPlayers = (_missionPublic get "players") call para_g_fnc_netmap_count;
private _alertness = _mission get "director" get "alertness";
private _baseUnitsPerPlayer = linearConversion [0, 90, _alertness, 2, 6, true];
// Scale with mission player count, not target player count (_players).
// This is to make it more punishing going solo in a group setting.
private _playerCountScaling = linearConversion [1, 6, _missionPlayers, 1, 4];
private _unitQuantity = floor (count _players * _baseUnitsPerPlayer * _playerCountScaling);
private _unitsRemaining = _unitQuantity;


[format ["[Reinforcements - Mission: %1, Players: %2] Reinforcing with %3 units (%4 base, %5x player scaling)",
    _missionId, _players, _unitQuantity, _baseUnitsPerPlayer, _playerCountScaling
]] call vgm_g_fnc_logDebug;

private _squads = [];
private _minSquadSize = 3;
private _maxSquadSize = 6;
private _squadSizeVariation = _maxSquadSize - _minSquadSize;
while {_unitsRemaining > 0} do {
    // Spawns X units, + Y extra units, where Y is between 1 and 3, but Y is always less than or equal to _unitsRemaining
    private _squadSize = _minSquadSize + (( 1 + floor random _squadSizeVariation) min (_unitsRemaining - _minSquadSize) max 0);

    private _template = [vgm_s_director_attack_classes select [0, _squadSize], _spawnPos, _missionId] call vgm_s_fnc_director_getEnemySquadTemplate;
    _template set ["deleteOnDespawn", true];
    _template get "groupVars" set ["vgm_g_order", [
        createHashMapFromArray [
            ["type", "ASSAULT"],
            ["pos", _attackPos]
        ]
    ]];

    _unitsRemaining = _unitsRemaining - _squadSize;

    [format ["[Reinforcements - Mission: %1, Players: %2] Creating reinforcement squad (%3 units, %4 remaining)",
        _missionId, _players, _squadSize, _unitsRemaining
    ]] call vgm_g_fnc_logDebug;

    _squads pushBack ([_template] call vgm_s_fnc_virtsquad_create);
};

_squads
