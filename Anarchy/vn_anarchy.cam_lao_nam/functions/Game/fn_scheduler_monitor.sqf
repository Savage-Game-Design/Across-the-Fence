/*
 * File: fn_scheduler_monitor.sqf
 * Author: Spoffy
 * Description:
 *    A simple script that monitors the scheduler, and restarts it if it crashes.
 * Params:
 *    None
 * Returns:
 *    None
 * Example Usage:
 *    [] spawn vn_mf_fnc_scheduler_monitor
 */

 vn_mf_monitorScheduler = true;

private _lastTick = 0;
private _checkFrequency	= 10;

 while {vn_mf_monitorScheduler} do {
	if (_lastTick + _checkFrequency > diag_tickTime) exitWith {};

	 if (!isNil "vn_mf_schedulerHandle") then {
		 if (scriptDone vn_mf_schedulerHandle) then {
			 [] call vn_mf_fnc_scheduler_start;
		 };
	 };
 };
