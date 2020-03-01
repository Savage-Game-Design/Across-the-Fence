/*
 * File: fn_event_subsystem_init.sqf
 * Author: Spoffy
 * Description:
 *    Initialises the event subsystem.
 * Params:
 *    None
 * Returns:
 *    None
 * Example Usage:
 *    call vn_an_fnc_event_subsystem_init
 */

vn_an_eventQueue = [];

["event_dispatcher", vn_an_fnc_event_dispatcher_job, [], 1] call vn_an_fnc_scheduler_add_job