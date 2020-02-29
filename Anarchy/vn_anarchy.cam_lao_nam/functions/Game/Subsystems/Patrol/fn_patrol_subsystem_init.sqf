/*
 * File: fn_patrol_init.sqf
 * Author: Spoffy
 * Description:
 *    Initialises the patrol subsystem.
 * Params:
 *    None
 * Returns:
 *    None
 * Example Usage:
 *    call vn_mf_fnc_patrol_init
 */

vn_mf_patrols = [];

["patrol_manager", vn_mf_fnc_patrol_job, [], 5] call vn_mf_fnc_scheduler_add_job;