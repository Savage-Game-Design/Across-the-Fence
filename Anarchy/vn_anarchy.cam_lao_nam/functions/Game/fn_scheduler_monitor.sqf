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
 *    [] spawn vn_an_fnc_scheduler_monitor
 */

 vn_an_monitorScheduler = true;

 while {vn_an_monitorScheduler} do {
	 if (!isNil "vn_an_schedulerHandle") then {

		 if (scriptDone vn_an_schedulerHandle) then {
			 [] call vn_an_fnc_scheduler_start;
		 };
	 };
	uiSleep 1;
 };
