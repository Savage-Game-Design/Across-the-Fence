/*
 * File: fn_zone_make_active.sqf
 * Author: Spoffy
 * Description:
 *    Makes a currently inactive zone active, seeding its initial primary tasks.
 * Params:
 *    _zone - Name of zone to make active
 * Returns:
 *    None
 * Example Usage:
 *    "zone_saigon" call vn_mf_fnc_zone_make_active;
 */

params ["_zone"];

vn_mf_activeZones pushBack _zone;

//Start the job that runs the zone
[format ["zone_active_%1", _zone], vn_mf_fnc_zone_active_job, [_zone], 15] call vn_mf_fnc_scheduler_add_job;