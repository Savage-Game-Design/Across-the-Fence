/*
 * File: fn_task_sec_kill_officer.sqf
 * Author: Spoffy
 * Description:
 *    Find and kill the enemy officer.
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
 *	  None
 */

params ["_dataStore"];

_dataStore setVariable ["INIT", {
	params ["_taskDataStore"];

	private _zonePos = getMarkerPos (_taskDataStore getVariable "taskMarker");
	private _spawnPos =_taskDataStore getVariable ["pos", [_zonePos, 500, 1000, 0, 0] call BIS_fnc_findSafePos];

	if (count _spawnPos == 2) then {_spawnPos pushBack 0};

	private _relevantGroups = _taskDataStore getVariable "taskGroups" apply {missionNamespace getVariable [_x, grpNull]};
	private _relevantPlayerCount = _relevantGroups call vn_mf_fnc_count_units_in_groups;
	private _unitCount = if (param_ai_quantity == 0) then { 1 } else { _relevantPlayerCount * 3 };
	private _result = [_spawnPos, _unitCount] call vn_mf_fnc_create_camp;
	private _createdThings = _result select 0;

	private _officerGroup = createGroup east;
	private _officer = [_officerGroup, selectRandom units_vc_officer, _spawnPos getPos [random 5, random 360], [], 5, "NONE"] call vn_mf_fnc_create_unit;

	//Add the officer to the list of units.
	(_createdThings select 1) pushBack _officer;
	(_createdThings select 2) pushBack _officerGroup;

	_taskDataStore setVariable ['campPos', _spawnPos];
	_taskDataStore setVariable ["officer", _officer];
	_taskDataStore setVariable ["vehicles", _createdThings select 0];
	_taskDataStore setVariable ["units", _createdThings select 1];
	_taskDataStore setVariable ["groups", _createdThings select 2];

	//Add inaccuracy to the marker, to force them to search.
	private _markerPos = [[[_spawnPos, 200]]] call BIS_fnc_randomPos;
	
	[[["kill_officer", _markerPos]]] call _fnc_initialSubtasks;
}];

_dataStore setVariable ["kill_officer", {
	params ["_taskDataStore"];

	if (alive (_taskDataStore getVariable "officer")) exitWith {};

	["SUCCEEDED"] call _fnc_finishSubtask;
	["SUCCEEDED"] call _fnc_finishTask;
}];

_dataStore setVariable ["FINISH", {
	params ["_taskDataStore"];

	[_taskDataStore getVariable ["vehicles", []]] call vn_mf_fnc_cleanup_addItems;
	[_taskDataStore getVariable ["units", []]] call vn_mf_fnc_cleanup_addItems;
}];