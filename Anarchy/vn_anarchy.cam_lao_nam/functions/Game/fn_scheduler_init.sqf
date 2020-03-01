/*
  Author: Aaron Clark

  Description:
	initialize scheduler events

  Example Usage:
	call vn_an_fnc_scheduler_init;

  Returns:
	NOTHING

  Parameter(s):
*/

// broadcast total time elapsed - initial
missionNamespace setVariable ["vn_an_totalgametime",["GET", "game_time", 0] call vn_an_fnc_hive,true];
["save_time_elapsed", {call vn_an_fnc_save_time_elapsed}, [], 5] call vn_an_fnc_scheduler_add_job;

// setup player health stats tracking
private _stats_cfg = (missionConfigFile >> "gamemode" >> "stats");
_health_config =
[
	(["difficulty", "hunger_loss_factor", 0.1] call vn_an_fnc_get_gamemode_value),
	(["difficulty", "thirst_loss_factor", 0.1] call vn_an_fnc_get_gamemode_value),
	getNumber(_stats_cfg >> "hunger" >> "loss_rate"),
	getNumber(_stats_cfg >> "thirst" >> "loss_rate"),
	getNumber(_stats_cfg >> "hunger" >> "min"),
	getNumber(_stats_cfg >> "thirst" >> "min"),
	getNumber(_stats_cfg >> "hunger" >> "max"),
	getNumber(_stats_cfg >> "thirst" >> "max"),
	getArray(_stats_cfg >> "attributes" >> "hunger"),
	getArray(_stats_cfg >> "attributes" >> "thirst")
];
["player_health_stats",compile (str _health_config + " call vn_an_fnc_player_health_stats"), [], 10] call vn_an_fnc_scheduler_add_job;
