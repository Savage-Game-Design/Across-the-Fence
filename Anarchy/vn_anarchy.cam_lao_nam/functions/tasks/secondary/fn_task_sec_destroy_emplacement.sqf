/*
 * File: fn_task_sec_destroy_emplacement.sqf
 * Author: Spoffy
 * Description:
 *    Destroy Gun Emplacement task
 * Params:
 *    _dataStore: Namespace for storing state machine info.
 * Returns:
 *    None
 * Example Usage:
 *    Shouldn't be called directly.
 *
 * Task Parameters:
 *    None
 * Subtask Parameters:
 *    None
 */

params ["_dataStore"];


_dataStore setVariable ["INIT", {
	params ["_taskDataStore"];

	private _markerPosition = getMarkerPos (_taskDataStore getVariable "taskMarker");

	private _spawnPosition = _taskDataStore getVariable ["pos", []];

	if (_spawnPosition isEqualTo []) then {
		//Find a random position at least X distance away from the zone, but less than Y.
		private _roughSpawnPosition = [[[_markerPosition, 500]], [[_markerPosition, 300]]] call BIS_fnc_randomPos;

		//Now find the best place to spawn.
		private _spawnPositions = selectBestPlaces [_roughSpawnPosition, 20, "1 - (0.5 - forest) * (0.5 - forest) - waterDepth", 20, 1];

		_spawnPosition = if (_spawnPositions isEqualTo []) then {_roughSpawnPosition} else {_spawnPositions select 0 select 0};
	};



	//selectBestPlaces returns position2D, so convert to position3D.
	if (count _spawnPosition == 2) then {
		_spawnPosition pushBack 0;
	};

	private _relevantGroups = _taskDataStore getVariable "taskGroups" apply {missionNamespace getVariable [_x, grpNull]};
	private _relevantPlayerCount = _relevantGroups call vn_mf_fnc_count_units_in_groups;
	private _unitCount = if (param_ai_quantity == 0) then { 1 } else { _relevantPlayerCount * 3 };
	private _result = [_spawnPosition, _unitCount] call vn_mf_fnc_create_aa_emplacement;
	private _createdThings = _result select 0;

	_taskDataStore setVariable ["aaPosition", _spawnPosition];
	_taskDataStore setVariable ["aaGuns", _result select 1];
	_taskDataStore setVariable ["vehicles", _createdThings select 0];
	_taskDataStore setVariable ["units", _createdthings select 1];
	_taskDataStore setVariable ["groups", _createdthings select 2];
	
	[[["destroy_emplacement", _spawnPosition]]] call _fnc_initialSubtasks;
}];

_dataStore setVariable ["destroy_emplacement", {
	params ["_taskDataStore"];

	private _anyGunsAlive = {alive _x} count (_taskDataStore getVariable "aaGuns") > 0;

	if (!([[_taskDataStore getVariable "aaPosition", 50, 50]] call vn_mf_fnc_check_enemy_units_alive) && _anyGunsAlive) exitWith {};

	["SUCCEEDED"] call _fnc_finishSubtask;
	["SUCCEEDED"] call _fnc_finishTask;
}];

_dataStore setVariable ["FINISH", {
	params ["_taskDataStore"];

	[_taskDataStore getVariable ["vehicles", []]] call vn_mf_fnc_cleanup_addItems;
	[_taskDataStore getVariable ["units", []]] call vn_mf_fnc_cleanup_addItems;
}];