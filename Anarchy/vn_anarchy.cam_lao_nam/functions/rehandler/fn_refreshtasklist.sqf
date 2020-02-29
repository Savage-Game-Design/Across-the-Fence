/*
 * File: fn_refreshtasklist.sqf
 * Author: Spoffy
 * Description:
 *    Request the server to send down the most up to date list.
 *
 *    Implemented via a request rather than publicVariable, to make it less brittle. Making sure the public variable updates every time a task/subtask is created/deleted
 *    is asking for synchronisation problems down the line, as some particular path through the code fails to update it correctly.
 * Params:
 *    None
 * Returns:
 *    None
 * Example Usage:
 *    [] call vn_mf_fnc_refreshtasklist;
 */

//Handled this way to ensure players can't force task refreshes on other players.
//I don't think it would cause an issue, but better safe than sorry when it comes to security.
 [_player] call vn_mf_fnc_task_refresh_task_list;
