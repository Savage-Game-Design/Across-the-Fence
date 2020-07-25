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
 *    call vn_an_fnc_patrol_init
 */

vn_an_patrols = [];

["patrol_manager", vn_an_fnc_patrol_job, [], 5] call vn_an_fnc_scheduler_add_job;