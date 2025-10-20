/*
    File: fn_director_spawnAmbientZombies.sqf
    Author: Savage Game Design
    Date: 2025-10-25
    Last Update: 2025-10-25
    Public: No

    Description:
        Spawns evenly spaced zombies around the whole target box for the given mission.

    Parameter(s):
        _mission - Mission to spawn zombies in [HASHMAP]

    Returns:
        Array of spawned squads [ARRAY]

    Example(s):
        [[0] call vgm_s_fnc_missions_getById] call vgm_s_fnc_director_spawnAmbientZombies;
 */

params ["_mission"];

private _targetZone = _mission get "public" get "targetZone";
private _zombieTemplate = [[], [0,0,0], _mission get "public" get "id"] call vgm_s_fnc_director_getZombieSquadTemplate;

private _squads = [];

[_targetZone] call vgm_g_fnc_loc_getTargetBoxBounds params ["_targetBoxCenter", "_targetBoxApothems"];
private _zombieSpacing = 200;
private _xZombieCount = floor ((_targetBoxApothems # 0) * 2 / _zombieSpacing);
private _yZombieCount = floor ((_targetBoxApothems # 1) * 2 / _zombieSpacing);
private _startPos = _targetBoxCenter vectorAdd [-(_targetBoxApothems # 0), -(_targetBoxApothems # 1)];

for "_xi" from 1 to _xZombieCount do {
    for "_yi" from 1 to _yZombieCount do {
        private _spawnPos = _startPos vectorAdd [_xi * _zombieSpacing, _yi * _zombieSpacing];

        _zombieTemplate set ["pos", _spawnPos];
        private _zombieClass = (selectRandom vgm_s_director_patrol_classes) + (selectRandomWeighted vgm_s_director_staticZombieWeightings);
        _zombieTemplate set ["composition", [_zombieClass]];
        private _zombieSquad = [_zombieTemplate] call vgm_s_fnc_virtsquad_create;
        _squads pushBack _zombieSquad;
    };
};

_squads
