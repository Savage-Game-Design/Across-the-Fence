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
 *    call vn_mf_fnc_cleanup_subsystem_init
 */

vn_mf_cleanup_minPlayerDistance = 1000;

vn_mf_cleanup_items = [];

["cleanup", vn_mf_fnc_cleanup_job, [], 60] call vn_mf_fnc_scheduler_add_job;