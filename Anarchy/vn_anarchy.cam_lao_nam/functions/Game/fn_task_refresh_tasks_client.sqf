/*
 * File: fn_task_refresh_tasks_client.sqf
 * Author: Spoffy
 * Description:
 *    Updates the client's task list with the task state currently available in the BIS Task framework.
 *    Used to handle situations where the state of the task isn't sync'ing properly (usually because it's targeting a group).
 * Params:
 *    _taskIds - Array of task Ids
 * Returns:
 *    None
 * Example Usage:
 *    On Server:
 *        [["id_1", "id_2"]] remoteExecCall ["vn_an_fnc_task_refresh_tasks_client", 0];
 *    On Client:
 *        (call vn_an_fnc_task_refresh_tasks_client);
  Valid On:
 *    Client only
 */

params ["_taskIds"];


//If we have no taskIds to update, then request the taskids from the server.
if (isNil "_taskIds") exitWith {
	[player, "refreshtasklist", [], player getVariable "vn_an_token"] remoteExec ["vn_an_fnc_rehandler",2];
};

{
	//Remove all tasks locally.
	//We have to do this in a way that respects the task system.
	//Otherwise the poor thing gets confused and stops working.
	private _taskVariable = _x call BIS_fnc_taskVar;
	private _simpleTask = player getVariable [_taskVariable, taskNull];
	player removeSimpleTask _simpleTask;
	player setVariable [_taskVariable, nil];

	//Reinitialise the simple task from the task system.
	[_x, false] call BIS_fnc_setTaskLocal;
} forEach _taskIds;
