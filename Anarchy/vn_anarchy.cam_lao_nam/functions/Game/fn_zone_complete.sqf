/*
 * File: fn_zone_complete.sqf
 * Author: Spoffy
 * Description:
 *    Makes a currently active zone completed, currently the same as 'inactive'
 * Params:
 *    _zone - Name of zone to make inactive
 * Returns:
 *    None
 * Example Usage:
 *    "zone_saigon" call vn_mf_fnc_zone_complete;
 */

params ["_zone"];

vn_mf_activeZones deleteAt (vn_mf_activeZones find _zone);

[format ["zone_active_%1", _zone]] call vn_mf_fnc_scheduler_remove_job;

["zoneCompleted", _zone] call vn_mf_fnc_event_dispatch;