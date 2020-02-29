/*
 * File: fn_task_sup_transport.sqf
 * Author: Spoffy
 * Description:
 *	  Support task to insert the given group into a location.
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

	private _startPosConfig = (getArray (_taskParameters >> "startPos"));
	private _destPosConfig = (getArray (_taskParameters >> "destinationPos"));

	if (_startPosConfig select 0 == "supportPos") then {
		_taskDataStore setVariable ["startPos", _taskDataStore getVariable "supportRequestPos"];
	} else {
		_taskDataStore setVariable ["startPos", (_startPosConfig) call vn_mf_fnc_parse_pos_config];
	};

	if (_destPosConfig select 0 == "supportPos") then {
		_taskDataStore setVariable ["destinationPos", _taskDataStore getVariable "supportRequestPos"];
	} else {
		_taskDataStore setVariable ["destinationPos", (_destPosConfig) call vn_mf_fnc_parse_pos_config];
	};

	_taskDataStore setVariable ["playersToTransport", [_taskDataStore getVariable "supportRequestPlayer"]];

	[[["mount", _taskDataStore getVariable "startPos"]]] call _fnc_initialSubtasks;
}];

_taskDataStore setVariable ["mount", {
	params ["_taskDataStore"];

	private _playersToTransport = (_taskDataStore getVariable "playersToTransport") select {alive _x};
	private _playerOne = _playersToTransport select 0;

	//if the first player isn't in a vehicle, we're clearly not all aboard.
	if (vehicle _playerOne isEqualTo _playerOne) exitWith {};
	//Check the driver of the vehicle is from the group fulfilling the task request
	if !(groupid group driver vehicle _playerOne in (_taskDataStore getVariable "taskGroups")) exitWith {};
	//Check all players are aboard
	if (_playersToTransport findIf {vehicle _x != vehicle _playerOne} > -1) exitWith {};

	["SUCCEEDED", [["transport", _taskDataStore getVariable "destinationPos"]]] call _fnc_finishSubtask;
}];

_taskDataStore setVariable ["transport", {
	params ["_taskDataStore"];

	private _playersToTransport = (_taskDataStore getVariable "playersToTransport") select {alive _x};

	//if all the players are dead, we failed.
	if (_playersToTransport isEqualTo []) exitWith {
		["FAILED"] call _fnc_finishSubtask;
		["FAILED"] call _fnc_finishTask;
	};

	private _allPlayersDisembarked = _playersToTransport findIf {vehicle _x != _x} == -1;

	if (_allPlayersDisembarked && count (_playersToTransport inAreaArray [_taskDataStore getVariable "destinationPos", 50, 50]) == count _playersToTransport) exitWith {
		["SUCCEEDED"] call _fnc_finishSubtask;
		["SUCCEEDED"] call _fnc_finishTask;
	};
}];

_taskDataStore setVariable ["FINISH", {
}];