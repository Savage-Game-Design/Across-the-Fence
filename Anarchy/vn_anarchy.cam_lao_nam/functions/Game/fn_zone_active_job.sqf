/*
 * File: fn_zone_active_job.sqf
 * Author: Spoffy
 * Description:
 *    Job that runs when a zone is active, creating and managing tasks and dynamic elements.
 * Params:
 *    None
 * Returns:
 *    None
 * Example Usage:
 *    Example usage goes here
 */

params ["_zone"];

private _jobStore = _schedulerCurrentJob;

//Tasks stored in format: [class, [frameworkTaskId, taskDataStore]]
private _currentPrimary = _jobStore getVariable ["currentPrimary", []];

if (_currentPrimary isEqualTo []) then {
	if (_zone == "zone_ba_ria") then {
		_jobStore setVariable [
			"currentPrimary", 
			["primary_1_ba_ria", ["primary_1_ba_ria", "zone_ba_ria"] call vn_mf_fnc_task_create]
		];
	};
	if (_zone == "zone_saigon") then {
		_jobStore setVariable [
			"currentPrimary", 
			["primary_1_saigon", ["primary_1_saigon", "zone_saigon"] call vn_mf_fnc_task_create]
		];
	};
} else {
	private _primaryDataStore = _currentPrimary select 1 select 1;
	//If we've finished the task.
	if (isNull _primaryDataStore || _primaryDataStore getVariable ["task_complete", false]) then {
		//Create next task
	};
};

//Handle secondary tasks

private _desiredTasksPerTeam = 2;

//All log entries before this time should be discarded.
private _logExpiryTime = diag_tickTime - (60 * 5);
vn_mf_taskCompletionLog = vn_mf_taskCompletionLog select {_x # 0 > _logExpiryTime};
private _recentlyCompletedTaskClasses = vn_mf_taskCompletionLog select {_x # 2 == _zone} apply {_x # 1};

//Everything that was completed in the last X minutes is invalid to spawn again.
private _invalidMikeForceSecondaries = [];
private _invalidSpikeTeamSecondaries = [];
private _invalidGreenHornetsSecondaries = [];
private _invalidAcavSecondaries = [];

private _activeMikeForceSecondaries = [];
private _activeSpikeTeamSecondaries = [];
private _activeGreenHornetsSecondaries = [];
private _activeAcavSecondaries = [];

//Anything currently 
{
	private _taskDataStore = _x select 1;
	if (_taskDataStore getVariable "taskCategory" == "SEC" && _taskDataStore getVariable "taskMarker" == _zone) then {
		{
			if (_x == "MikeForce") then { _activeMikeForceSecondaries pushBack (_taskDataStore getVariable "taskClass"); };
			if (_x == "SpikeTeam") then { _activeSpikeTeamSecondaries pushBack (_taskDataStore getVariable "taskClass"); };
			if (_x == "GreenHornets") then { _activeGreenHornetsSecondaries pushBack (_taskDataStore getVariable "taskClass"); };
			if (_x == "ACAV") then { _activeAcavSecondaries pushBack (_taskDataStore getVariable "taskClass"); };
		} forEach (_taskDataStore getVariable "taskGroups");
	};
} forEach vn_mf_tasks;

private _invalidMikeForceSecondaries = _recentlyCompletedTaskClasses + _activeMikeForceSecondaries;
private _invalidSpikeTeamSecondaries = _recentlyCompletedTaskClasses + _activeSpikeTeamSecondaries;
private _invalidGreenHornetsSecondaries = _recentlyCompletedTaskClasses + _activeGreenHornetsSecondaries;
private _invalidAcavSecondaries = _recentlyCompletedTaskClasses + _activeAcavSecondaries;

if (count _invalidMikeForceSecondaries < _desiredTasksPerTeam) then {
	private _validTasks = (vn_mf_secondaryTasksBySide getVariable ["mikeForce", []]) - _invalidMikeForceSecondaries;
	if !(_validTasks isEqualTo []) then {
		[selectRandom _validTasks, _zone] call vn_mf_fnc_task_create;
	};
};

if (count _invalidSpikeTeamSecondaries < _desiredTasksPerTeam) then {
	private _validTasks = (vn_mf_secondaryTasksBySide getVariable ["spikeTeam", []]) - _invalidSpikeTeamSecondaries;
	if !(_validTasks isEqualTo []) then {
		[selectRandom _validTasks, _zone] call vn_mf_fnc_task_create;
	};
};

if (count _invalidGreenHornetsSecondaries < _desiredTasksPerTeam) then {
	private _validTasks = (vn_mf_secondaryTasksBySide getVariable ["greenHornets", []]) - _invalidGreenHornetsSecondaries;
	if !(_validTasks isEqualTo []) then {
		[selectRandom _validTasks, _zone] call vn_mf_fnc_task_create;
	};
};

if (count _invalidAcavSecondaries < _desiredTasksPerTeam) then {
	private _validTasks = (vn_mf_secondaryTasksBySide getVariable ["acav", []]) - _invalidAcavSecondaries;
	if !(_validTasks isEqualTo []) then {
		[selectRandom _validTasks, _zone] call vn_mf_fnc_task_create;
	};
};