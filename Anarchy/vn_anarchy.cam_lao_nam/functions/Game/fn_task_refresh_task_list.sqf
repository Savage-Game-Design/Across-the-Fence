/*
 * File: fn_task_refresh_task_list.sqf
 * Author: Spoffy
 * Description:
 *    Refreshes the task listings for a player. Removes all tasks, and repopulates the task list with the ones they need, according to our task system.
 *
 *    BIS task systems don't work especially well. In particular, when a player joins, they don't receive tasks sent only to their group. Additionally,
 *    when a player switches group, they don't lose the old group's tasks, or gain the new group's tasks.
 *
 *    This does a hard-wipe on a player's task list, and repopulates it, guaranteeing it'll be correct.
 * Params:
 *    _targets - Anything accepted by remoteExecCall's target list.
 * Returns:
 *    None
 * Example Usage:
 *	  player call vn_an_fnc_task_refresh_task_list
 */

params ["_targets"];

private _taskIds = [];

private _taskId = "";
private _taskDataStore = objNull;
{
	_taskId = _x select 0;
	_taskDataStore = _x select 1;

	_taskIds pushBack _taskId;
	_taskIds append (_taskDataStore getVariable ["taskSubtasks", []])
} forEach vn_an_tasks;

[_taskIds] remoteExecCall ["vn_an_fnc_task_refresh_tasks_client", _targets];
