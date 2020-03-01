/*
 * File: fn_cleanup_subsystem_init.sqf
 * Author: Spoffy
 * Description:
 *    Initialises the Cleanup Subsystem
 * Params:
 *    None
 * Returns:
 *    None
 * Example Usage:
 *    call vn_an_fnc_cleanup_subsystem_init
 */

vn_an_cleanup_minPlayerDistance = 1000;

vn_an_cleanup_items = [];

["cleanup", vn_an_fnc_cleanup_job, [], 60] call vn_an_fnc_scheduler_add_job;