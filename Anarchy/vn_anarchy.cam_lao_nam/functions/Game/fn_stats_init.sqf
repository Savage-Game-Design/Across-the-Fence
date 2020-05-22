/*
 * File: fn_stats_init.sqf
 * Author: Aaron Clark and Spoffy
 * Description:
 *    Initialises stats handling
 * Params:
 *    None
 * Returns:
 *    None
 * Example Usage:
 *    [] call vn_an_fnc_stats_init
 */

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
