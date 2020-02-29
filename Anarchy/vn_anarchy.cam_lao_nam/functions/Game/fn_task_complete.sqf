/*
  Author: Spoffy and Aaron Clark

  Description:
	Marks an existing task as complete and cleans up the tasks so there's no leaked resources.
	This is *only* for top-level tasks. *Not* subtasks.

  Example Usage:
    [vn_mf_tasks # 0 # 1, "SUCCEEDED"] call vn_mf_fnc_task_complete

  Parameters:
	_taskDataStore - DataStore from the task being completed.
	_completionType - Type of the completion. Valid are 'CANCELED', 'FAILED' and 'SUCCEEDED'

  Returns:
	Boolean - whether the task was successfully removed

  Parameter(s):
*/

params ["_taskDataStore", "_completionType"];

private _taskClass = _taskDataStore getVariable "taskClass";
private _taskArrayPos = vn_mf_tasks findIf {_x select 1 isEqualTo _taskDataStore};

//Invalid task! Abort! Abort!
if (_taskArrayPos < 0) exitWith {
	false
};

if !(_completionType in ['CANCELED', 'FAILED', 'SUCCEEDED']) exitWith {
	diag_log format ["Not completing task %1 due to invalid completion type %2", _taskClass, _completionType];
	false
};

private _task = vn_mf_tasks select _taskArrayPos;

//Remove the task from the tasks array, to avoid us thinking it's an active task later.
vn_mf_tasks deleteAt _taskArrayPos;

//Firstly - we set a flag in the taskDataStore, to inform the task we're done with it.
//This gives the task a chance to handle its own exit, and do its own cleanup. Then we don't have to worry about it.
//The task monitoring system should also use this to know which tasks can be removed safely.
//That's why we do this before any other checks kick in.
_taskDataStore setVariable ["task_completed", true];

//Now we tell the scheduler we don't need to run the task anymore - it's done!
//We use the task's Task Framework id for this.
[_task select 0] call vn_mf_fnc_scheduler_remove_job;

//Tell Bohemia's Task Framework we won! (Or lost)
[_task select 0, _completionType, true] call BIS_fnc_taskSetState;

//Add the completion to our finish log, with the time it finished.
vn_mf_taskCompletionLog pushBack [diag_tickTime, _taskClass, _taskDataStore getVariable "taskMarker"]; 

//Essentials are all done now. Now we focus on updating the gamemode state.

private _taskConfig = _taskDataStore getVariable ["taskConfig", configNull];
//Oh. Somehow we lost the task config. That's... pretty bad.
if (_taskConfig == configNull) exitWith {
	diag_log format ["ERROR: Lost the task config for %1.", _taskClass];
	false;
};

//Note: This is *changed* from the original implementation.
//Specifically, we now only award zone progress if the task was completed successfully.

if (_completionType isEqualTo "SUCCEEDED") then
{
	//Firstly - we reward rankpoints to all players in the involved groups. Huzzah,  rank points for all!
	private _rankPointsReward = getNumber(_taskConfig >> "rankpoints");
	if !(_rankPointsReward isEqualTo 0) then
	{
		private _taskGroups = _taskDataStore getVariable ["taskGroups", []] apply {missionNamespace getVariable [_x, grpNull]};
		{
			private _grp = _x;
			if !(_grp isEqualTo grpNull) then
			{
				[_grp, _rankPointsReward] call vn_mf_fnc_player_rank;
			};
		} forEach _taskGroups;
	};

	//This should probably be its own function, honestly.
	//We should also think about how we can handle losing progress on failure.
	private _zoneMarker = _taskDataStore getVariable "taskMarker";
	if (_zoneMarker != "") then {
		private _addedZoneProgress = getNumber(_taskConfig >> "taskprogress");
		private _zoneProgressKey = (_zoneMarker + "progress");
		private _currentZoneProgress = missionNamespace getVariable [_zoneProgressKey, 0];
		private _newProgress = _currentZoneProgress + _addedZoneProgress min 100;

		//Calculate our new marker colour based on progress.
		private _newZoneColorStr = [_newProgress] call vn_mf_fnc_progress_to_color_config;
		[_zoneMarker, _newZoneColorStr] spawn BIS_fnc_colorMarker;
		//Update zone marker text
		_zoneProgressKey setMarkerText format["%1%2", _newProgress toFixed 0,"%"];

		// display zone task has changed prgress
		_zoneProgressKey setMarkerAlpha 0.5;
		_zoneMarker setMarkerAlpha 0.5;

		//Save new zone progress.
		missionNamespace setVariable [_zoneProgressKey, _newProgress];
		["SET", _zoneProgressKey, _newProgress] call vn_mf_fnc_hive;
	};

	// Force a save to profileNamespace (force save to write to disk, basically)
	["SAVE"] call vn_mf_fnc_hive;
};

//Finally, confident everything else is done, we can call the onComplete handler for the task.
[_completionType, _taskDataStore] call compile getText ((_taskDataStore getVariable "taskConfig") >> "onCompletion");
["taskCompleted", _taskDataStore] call vn_mf_fnc_event_dispatch;

//TODO Delete the task data store in here.
