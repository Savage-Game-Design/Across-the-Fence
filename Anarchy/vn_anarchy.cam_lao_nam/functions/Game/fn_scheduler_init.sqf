/*
  Author: Aaron Clark

  Description:
	sets up initial task

  Example Usage:
	call vn_an_fnc_scheduler_init;

  Returns:
	NOTHING

  Parameter(s):
*/

// broadcast total time elapsed - initial
missionNamespace setVariable ["vn_an_totalgametime",["GET", "game_time", 0] call vn_an_fnc_hive,true];
["save_time_elapsed", {call vn_an_fnc_save_time_elapsed}, [], 5] call vn_an_fnc_scheduler_add_job;

// building state tracking
// ["building_state_tracker", {call vn_an_fnc_building_state_tracker}, [], 60] call vn_an_fnc_scheduler_add_job;

// do slow allplayers list updates
// ["player_list_tracker", {call vn_an_fnc_player_list_tracker}, [], 15] call vn_an_fnc_scheduler_add_job;
