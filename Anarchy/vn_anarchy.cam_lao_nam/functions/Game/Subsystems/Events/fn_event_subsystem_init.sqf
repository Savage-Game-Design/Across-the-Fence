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
 *    call vn_mf_fnc_event_subsystem_init
 */

vn_mf_eventQueue = [];

["event_dispatcher", vn_mf_fnc_event_dispatcher_job, [], 1] call vn_mf_fnc_scheduler_add_job