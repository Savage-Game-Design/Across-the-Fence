/*
  Author: Spoffy

  Description:
	Called every scheduler tick to maintain the "Ash and Trash" task.

	This is an example of a 'raw' task system task, that isn't using one the task system 'framework' scripts. This is driven directly by the task system.
  Params:
	_taskDataStore - Data store for the task that's using this script. Created by the task system.

  Returns:
	None

  Example Usage:
	Shouldn't be called directly.
*/

params ["_taskDataStore"];

private _currentTaskState = _taskDataStore getVariable ["taskState", "INIT"];

if (_currentTaskState == "INIT") then {
	private _crateSpawnPosition = _taskDataStore getVariable ["crateSpawnPos", getMarkerPos "respawn_west_greenhornets"];
	private _crate = "B_CargoNet_01_ammo_F" createVehicle _crateSpawnPosition;
	_taskDataStore setVariable ["crate", _crate];
	//Assumption: Crate was successfully created 

	[_taskDataStore, "load_supplies", _crateSpawnPosition] call vn_mf_fnc_task_subtask_create;
	_currentTaskState = "LOADING_SUPPLIES";
	_taskDataStore setVariable ["taskState", _currentTaskState];
};

//Error on failure - crate should ALWAYS be defined if we hit this point.
private _crate = _taskDataStore getVariable "crate";

if (_currentTaskState == "LOADING_SUPPLIES") exitWith {
	if !(typeOf ropeAttachedTo _crate isKindOf "Air") exitWith {};

	[_taskDataStore, "load_supplies", "SUCCEEDED"] call vn_mf_fnc_task_subtask_complete;

	private _crateDestination = _taskDataStore getVariable ["crateDestPos", getMarkerPos (_taskDataStore getVariable "taskMarker")];
	[_taskDataStore, "transport_supplies", _crateDestination] call vn_mf_fnc_task_subtask_create;

	_taskDataStore setVariable ["crateDestination", _crateDestination];
	_taskDataStore setVariable ["taskState", "TRANSPORTING_SUPPLIES"];
};

if (_currentTaskState == "TRANSPORTING_SUPPLIES") exitWith {
	//This should always be defined if we're in this state.
	private _crateDestination = _taskDataStore getVariable "crateDestination";
	if !(_crate distance _crateDestination < 20 && {isNull ropeAttachedTo _crate}) exitWith {};

	[_taskDataStore, "transport_supplies", "SUCCEEDED"] call vn_mf_fnc_task_subtask_complete;
	[_taskDataStore, "SUCCEEDED"] call vn_mf_fnc_task_complete;

	[_crate] call vn_mf_fnc_cleanup_addItems;
};
