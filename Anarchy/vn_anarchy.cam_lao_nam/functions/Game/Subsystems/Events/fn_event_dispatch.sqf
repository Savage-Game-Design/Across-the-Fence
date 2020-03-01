/*
 * File: fn_event_dispatch.sqf
 * Author: Spoffy
 * Description:
 *    Adds an event to the event queue.
 *    DO NOT ADD LONG RUNNING TASKS TO THIS QUEUE.
 *    As it runs on the main scheduler, it will potentially blocks other aspects of the mission.
 * Params:
 *    None
 * Returns:
 *    None
 * Example Usage:
 *    ["onTaskComplete", [_taskDataStore]] call vn_an_fnc_event_dispatch;
 */

params ["_eventName", ["_params", []]];

vn_an_eventQueue pushBack [_eventName, _params];