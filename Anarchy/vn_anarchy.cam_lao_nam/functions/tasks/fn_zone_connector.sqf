/*
 * File: fn_task_zone_connector.sqf
 * Author: Spoffy
 * Description:
 *	  A task created by a dead zone to allow the players to trigger the next zone.
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
 * Runtime Parameters:
 *    oldZone - Name of the marker of the zone that was just completed
 *    newZone - Name of the marker of the zone to unlock
 *    position - Position to spawn the task marker
 */
params ["_taskDataStore"];

_taskDataStore setVariable ["INIT", {
	params ["_taskDataStore"];


	[[["build_checkpoint", _taskDataStore getVariable "position"]]] call _fnc_initialSubtasks;
}];

_taskDataStore setVariable ["build_checkpoint", {
	params ["_taskDataStore"];

	//If another connector has told us to abort, we abort.
	if (_taskDataStore getVariable ["abortConnector", false]) exitWith {
		["CANCELED"] call _fnc_finishSubtask;
		["CANCELED"] call _fnc_finishTask;
	};

	private _targetPosition = _taskDataStore getVariable "position";

	//Check if they've made a decision by building a checkpoint.
	if (vn_mf_checkpoints inAreaArray [_targetPosition, 50, 50, 0, false] findIf {alive _x} > -1) then {
		["SUCCEEDED"] call _fnc_finishSubtask;
		["SUCCEEDED"] call _fnc_finishTask;
	};
}];

_taskDataStore setVariable ["FINISH", {
	params ["_taskDataStore"];

	//We don't cancel the other connector tasks if we're not connector succeeding.
	if (_taskDataStore getVariable "stateMachineResult" != "SUCCEEDED") exitWith {};

	private _myOldZone = _taskDataStore getVariable "oldZone";

	_myOldZone call vn_mf_fnc_zone_complete;
	(_taskDataStore getVariable "newZone") call vn_mf_fnc_zone_make_active;

	//Not entirely happy with how we're cancelling the task.
	//Maybe cancelling should be built into the state machine framework?
	private _otherRelatedConnectors = vn_mf_tasks 
		select {_x select 1 getVariable "taskClass" == "zone_connector"}
		select {_x select 1 getVariable ["oldZone", ""] == _myOldZone};

	{
		private _store = _x select 1;
		_store setVariable ["abortConnector", true];
	} forEach _otherRelatedConnectors;
}];