/*
 * File: fn_sup_resupply.sqf
 * Author: Spoffy
 * Description:
 *	  Support task for moving a resupply crate to a target.
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
 *    crateSpawnPosition - initial position to spawn the resupply crate.
 * Subtask Parameters:
 * 	  None
 */

params ["_taskDataStore"];

_taskDataStore setVariable ["INIT", {
	params ["_taskDataStore"];

	private _taskConfig = _taskDataStore getVariable "taskConfig";
	private _taskParameters = _taskConfig >> "parameters";
	private _crateSpawnPos = (getArray (_taskParameters >> "crateSpawnPosition")) call vn_mf_fnc_parse_pos_config;

	private _crate = ["RESUPPLY"] call vn_mf_fnc_create_crate;
	//This'll be prone to Arma'ing.
	_crate setPos _crateSpawnPos;

	_taskDataStore setVariable ["crate", _crate];

	[[["collect_crate", _crateSpawnPos]]] call _fnc_initialSubtasks;
}];

_taskDataStore setVariable ["collect_crate", {
	params ["_taskDataStore"];

	private _crate = _taskDataStore getVariable ["crate", objNull];
	//wait until crate is connected to a vehicle or helicopter
	if (isNull ropeAttachedTo _crate && isNull isVehicleCargo _crate) exitWith {};

	private _deliverPosition = _taskDataStore getVariable "supportRequestPos";

	["SUCCEEDED", [["deliver_crate", _deliverPosition]]] call _fnc_finishSubtask;
}];

_taskDataStore setVariable ["deliver_crate", {
	params ["_taskDataStore"];

	private _crate = _taskDataStore getVariable ["crate", objNull];
	//wait until crate is detached with vehicle 
	if !(isNull ropeAttachedTo _crate && isNull isVehicleCargo _crate 
		&& (_crate distance2D (_taskDataStore getVariable "supportRequestPos") < 30)
		) exitWith {};

	["SUCCEEDED"] call _fnc_finishSubtask;
	["SUCCEEDED"] call _fnc_finishTask;
}];

_taskDataStore setVariable ["FINISH", {
	params ["_taskDataStore"];

	private _crate = _taskDataStore getVariable ["crate", objNull];

	[_crate] call vn_mf_fnc_cleanup_addItems;
}];