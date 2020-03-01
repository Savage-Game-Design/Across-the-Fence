/*
  Author: Spoffy

  Description:
	Marks an existing task as complete and cleans up the tasks so there's no leaked resources.
	This is *only* for top-level tasks. *Not* subtasks.

  Example Usage:
    [parentTaskDataStore, subtaskId, "SUCCEEDED"] call vn_an_fnc_task_subtask_create

  Parameters:
	_parentDataStore - Data store of the parent task.
	_subtaskId - Id of the subtask to create (currently classname)
	_completionType - One of 'SUCCEEDED', 'CANCELED' or 'FAILED'

  Returns:
	boolean
*/

params ["_parentDataStore", "_subtaskId", "_completionType"];

//Check we have a valid completion type. Abandon all hope if we aren't one of these!
if !(_completionType in ['CANCELED', 'FAILED', 'SUCCEEDED']) exitWith {
	diag_log format ["Not completing task %1 due to invalid completion type %2", _taskId, _completionType];
	false
};

private _parentTaskId = _parentDataStore getVariable ["taskId", ""];
private _subtaskTaskId = format ["%1_%2", _parentTaskId, _subtaskId];
private _parentSubtasks = _parentDataStore getVariable ["taskSubtasks", []];

private _subtaskArrayPos = _parentSubtasks find _subtaskTaskId;
//If we're not in the parents list of subtasks, we must not exist! Do nothing.
if (_subtaskArrayPos < 0) exitWith {
	false
};

//Don't remove the subtask from the parent's list of subtasks, so we can clean it up or reference later if needed.
//_parentTasks deleteAt _subtaskArrayPos;

//Return result of this taskSetState
[_subtaskTaskId, _completionType] call BIS_fnc_taskSetState

