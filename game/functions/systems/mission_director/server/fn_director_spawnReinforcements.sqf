/*
    File: fn_director_spawnReinforcements.sqf
    Author: Savage Game Design
    Date: 2024-11-02
    Last Update: 2025-05-12
    Public: Yes

    Description:
        Spawn enemy reinforcements to attack an engaged player.

    Parameter(s):


    Returns:
        The squad created, or nil if a squad couldn't be spawned. [GROUP]

    Example(s):
        [_mission, _player] call vgm_s_fnc_director_spawnReinforcements;
 */


params ["_mission", "_player"];

private _missionPublic = _mission get "public";
private _missionId = _missionPublic get "id";
private _spawnPos = [];

for "_i" from 1 to 3 do {
    _spawnPos = ([getPos _player, playableUnits, random 360, 0, 400] call para_g_fnc_spawning_find_valid_position_tracer) # 0;
    if (_spawnPos isNotEqualTo []) exitWith {};
};

if (_spawnPos isEqualTo []) exitWith { nil };

private _template = [vgm_s_director_attack_classes select [0, 5], _spawnPos, _missionId] call vgm_s_fnc_director_getEnemySquadTemplate;
_template set ["deleteOnDespawn", true];

[_template] call vgm_s_fnc_virtsquad_create
