/*
  Author: Spoffy

  Description:
	Marks an existing task as complete and cleans up the tasks so there's no leaked resources.
	This is *only* for top-level tasks. *Not* subtasks.

  Example Usage:
    [parentTaskDataStore, subtaskId] call vn_mf_fnc_task_subtask_create

  Parameters:
	_parentDataStore - Data store of the parent task.
	_subtaskId - Id of the subtask to create (currently classname)
	_subtaskPos - Position of the newly created subtask

  Returns:
	boolean
*/

params ["_parentDataStore", "_subtaskId", ["_subtaskPos", objNull]];

private _parentTaskId = _parentDataStore getVariable ["taskId", ""];
private _parentConfig = _parentDataStore getVariable ["taskConfig", configNull];
private _subtaskConfig = (_parentConfig >> _subtaskId);

if !(isClass _subtaskConfig) exitWith {
	diag_log format ["Unable to create subtask - invalid config %1", _subtaskConfig];
	false;
};

private _subtaskName = getText (_subtaskConfig >> "taskname");
private _subtaskDesc = getText (_subtaskConfig >> "taskdesc");
private _taskGroups = _parentDataStore getVariable ["taskGroups", []] apply {missionNamespace getVariable _x};

private _subtaskTaskId = format ["%1_%2", _parentTaskId, _subtaskId];

//TODO: Add more checks here to make sure we have all data needed to create subtask.

[_taskGroups, [_subtaskTaskId, _parentTaskId], [_subtaskDesc, _subtaskName, "Fish"], _subtaskPos, "AUTOASSIGNED", 2, true] call BIS_fnc_taskCreate;
_parentDataStore setVariable ["taskSubtasks", (_parentDataStore getVariable ["taskSubtasks", []]) + [_subtaskTaskId]];

true
