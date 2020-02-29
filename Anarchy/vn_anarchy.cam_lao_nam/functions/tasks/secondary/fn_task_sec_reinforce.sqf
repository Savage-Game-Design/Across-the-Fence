/*
 * File: fn_task_sec_reinforce.sqf
 * Author: Spoffy
 * Description:
 *    Reinforce units at the given position
 *    Uses the stateMachineTasksSystem
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
 *    None
 * Runtime Parameters:
 *    pos - Position to spawn the hostile infantry at.
 */

params ["_dataStore"];

_dataStore setVariable ["INIT", {
	params ["_taskDataStore"];

	private _taskConfig = _taskDataStore getVariable "taskConfig";
	private _zoneMarker = _taskDataStore getVariable "taskMarker";
	private _spawnPos = _taskDataStore getVariable ["pos", getMarkerPos _zoneMarker];

	private _relevantPlayerCount = count ("MikeForce" call vn_mf_fnc_units_on_team);
	private _unitCount = if (param_ai_quantity == 0) then { 1 } else { _relevantPlayerCount * 3 };
	private _squadComposition = [_unitCount] call vn_mf_fnc_squad_standard;
	private _result = [_squadComposition, east, _spawnPos] call vn_mf_fnc_create_squad;

	private _friendlySpawnPos = [[[_spawnPos, 100]]] call BIS_fnc_randomPos;

	private _friendlyUnits = [[_friendlySpawnPos,'vn_mf_task_com_1'] call vn_mf_fnc_spawn_civilian];

	_taskDataStore setVariable ['enemySpawnPos', _spawnPos];
	_taskDataStore setVariable ["enemyUnits", _result select 0];
	_taskDataStore setVariable ["friendlyUnits", _friendlyUnits];
	_taskDataStore setVariable ["groups", _result select 1];

	
	[[["defend_troops", _friendlySpawnPos]]] call _fnc_initialSubtasks;
}];

_dataStore setVariable ["defend_troops", {
	params ["_taskDataStore"];

	private _friendlyUnitsAreAlive = (_taskDataStore getVariable "friendlyUnits") findIf {alive _x} > -1;

	if (!_friendlyUnitsAreAlive) exitWith {
		["FAILED"] call _fnc_finishSubtask;
		["FAILED"] call _fnc_finishTask;
	};

	private _enemyUnitsAreAlive = (_taskDataStore getVariable "enemyUnits") findIf {alive _x} > -1;

	if (!_enemyUnitsAreAlive) exitWith {
		private _friendlyPos = getPos (_taskDataStore getVariable "friendlyUnits" select 0);
		["SUCCEEDED", [["talk_to_commander", _friendlyPos]]] call _fnc_finishSubtask;
	};
}];

_dataStore setVariable ["talk_to_commander", {
	params ["_taskDataStore"];

	["SUCCEEDED"] call _fnc_finishSubtask;
	["SUCCEEDED"] call _fnc_finishTask;
}];

_dataStore setVariable ["FINISH", {
	params ["_taskDataStore"];

	[_taskDataStore getVariable ["friendlyUnits", []]] call vn_mf_fnc_cleanup_addItems;
	[_taskDataStore getVariable ["enemyUnits", []]] call vn_mf_fnc_cleanup_addItems;
}];