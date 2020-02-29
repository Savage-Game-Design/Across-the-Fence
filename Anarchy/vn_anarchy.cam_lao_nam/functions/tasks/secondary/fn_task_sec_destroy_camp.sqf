/*
 * File: fn_task_sec_destroy_camp.sqf
 * Author: Spoffy
 * Description:
 *    Destroy camp mission script for Mike Force
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
 *    find_and_destroy_camp:
 *        - pos: A position to be passed to parse_pos_config
 */

params ["_dataStore"];

_dataStore setVariable ["INIT", {
	params ["_taskDataStore"];

	private _zonePos = getMarkerPos (_taskDataStore getVariable "taskMarker");
	private _spawnPos = _taskDataStore getVariable ["pos", _zonePos getPos [200 + random 200, random 360]];

	private _relevantGroups = _taskDataStore getVariable "taskGroups" apply {missionNamespace getVariable [_x, grpNull]};
	private _relevantPlayerCount = _relevantGroups call vn_mf_fnc_count_units_in_groups;
	private _unitCount = if (param_ai_quantity == 0) then { 1 } else { _relevantPlayerCount * 3 };
	private _result = [_spawnPos, _unitCount] call vn_mf_fnc_create_camp;
	private _createdThings = _result select 0;

	_taskDataStore setVariable ['campPos', _spawnPos];
	_taskDataStore setVariable ["vehicles", _createdThings select 0];
	_taskDataStore setVariable ["units", _createdThings select 1];
	_taskDataStore setVariable ["groups", _createdThings select 2];

	//Add inaccuracy to the marker, to force them to search.
	private _markerPos = [[[_spawnPos, 200]]] call BIS_fnc_randomPos;
	
	[[["find_and_destroy_camp", _markerPos]]] call _fnc_initialSubtasks;
}];

_dataStore setVariable ["find_and_destroy_camp", {
	params ["_taskDataStore"];

	private _unitsAreAlive = (_taskDataStore getVariable "units") findIf {alive _x} > -1;

	if (_unitsAreAlive) exitWith {};

	["SUCCEEDED"] call _fnc_finishSubtask;
	["SUCCEEDED"] call _fnc_finishTask;
}];

_dataStore setVariable ["FINISH", {
	params ["_taskDataStore"];

	[_taskDataStore getVariable ["vehicles", []]] call vn_mf_fnc_cleanup_addItems;
	[_taskDataStore getVariable ["units", []]] call vn_mf_fnc_cleanup_addItems;
}];