/*
  Author: Aaron Clark

  Description:
	Spawns enemy at a markers location and scales number of enemy to number of players in marker

  Example Usage:
	['enemy_1'] call vn_mf_fnc_spawn_enemy_units;

  Returns:
	GROUP

  Parameter(s):
*/
params [
	"_marker",					// 0: STRING - marker name used for spawn location
	["_spawnpos", []],				// 1: ARRAY - spawn position, [] for random pos
	["_class","uns_men_NVA_daccong_MRK"]		// 2: STRING - Class enemy to spawn (optional)
];

if (_spawnpos isEqualTo []) then
{
	_spawnpos = [[_marker],["water"]] call BIS_fnc_randomPos;
};

// get number of players in zone,
_num_players_in_zone = count ((allUnits inAreaArray _marker) select {alive _x && side _x == west});
// spawn units
_classes_to_spawn = [_class];


// difficulty
_skill = ["difficulty", "aiskill", 0.1] call vn_mf_fnc_get_gamemode_value;
diag_log format ["_skill: %1",_skill];

for "_i" from 1 to _num_players_in_zone do
{
	_classes_to_spawn pushBack _class;
};

// spawn group
_group = [ _spawnpos, EAST, _classes_to_spawn,[],[],[_skill,_skill],[],[_num_players_in_zone/2 max 1,0.5],random 360,false,_num_players_in_zone] call BIS_fnc_spawnGroup;

// mark group for removal
_group deleteGroupWhenEmpty true;

_group
