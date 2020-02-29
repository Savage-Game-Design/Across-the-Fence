/*
  Author: Aaron Clark

  Description:
	calculates saves and broadcasts total game time elapsed

  Example Usage:
	call vn_mf_fnc_save_time_elapsed;

  Returns:
	NUMBER - calculate and return total game time

  Parameter(s):
	NA
*/
private _ticktime = diag_ticktime;

// init time elapsed counter
if (isNil "vn_mf_lastticktime") then
{
	vn_mf_lastticktime = _ticktime;
};

// get current time
(["GET", "game_time", 0] call vn_mf_fnc_hive) params ["","_savedtime"];

// increment by time elapsed since last activation
private _elapsedtime = _ticktime - vn_mf_lastticktime;

(["SET", "game_time", (_savedtime + _elapsedtime)] call vn_mf_fnc_hive) params ["","_savedtime"];

// broadcast total time elapsed -	update
missionNamespace setVariable ["vn_mf_totalgametime",_savedtime,true];

// do ttl check on db
["TTLCHECK"] call vn_mf_fnc_hive;
// force db save periodically
["SAVE"] call vn_mf_fnc_hive;

// update internal counter
vn_mf_lastticktime = _ticktime;

_savedtime
