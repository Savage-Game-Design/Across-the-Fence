/*
 * File: fn_task_pri_9.sqf
 * Author: Spoffy
 * Description:
 *	  Primary task to destroy the VC HQ.
 *
 *    Uses the state machine task system.
 * Params:
 *    _taskDataStore: Namespace for storing task info.
 * Returns:
 *    None

 * Example Usage:
 *    Shouldn't be called directly.
 *
 * Task Parameters:
 *    None
 * Subtask Parameters:
 * 	  None
 */

params ["_taskDataStore"];

_taskDataStore setVariable ["INIT", {
	params ["_taskDataStore"];

	private _taskConfig = _taskDataStore getVariable "taskConfig";
	private _taskParameters = _taskConfig >> "parameters";

	private _spawnPos = (getArray (_taskParameters >> "spawnPosition")) call vn_mf_fnc_parse_pos_config;

	private _hqBuilding = ['Land_vn_b_trench_firing_05', [[[_spawnPos, 50]],[[_spawnPos, 25],'water']] ,'vn_mf_rnd_object_4'] call vn_mf_fnc_spawn_object;

	_taskDataStore setVariable ["spawnPos", _spawnPos];
	_taskDataStore setVariable ["hqBuilding", _hqBuilding];

	[[["destroy_hq", _spawnPos]]] call _fnc_initialSubtasks;
}];

_taskDataStore setVariable ["destroy_hq", {
	params ["_taskDataStore"];

	private _targetsAlive = alive (_taskDataStore getVariable "hqBuilding");

	if (!_targetsAlive) then {
		["SUCCEEDED"] call _fnc_finishSubtask;
		["SUCCEEDED"] call _fnc_finishTask;
	};
}];

_taskDataStore setVariable ["FINISH", {
	[_taskDataStore getVariable ["hqBuilding", objNull]] call vn_mf_fnc_cleanup_addItems;
}];
