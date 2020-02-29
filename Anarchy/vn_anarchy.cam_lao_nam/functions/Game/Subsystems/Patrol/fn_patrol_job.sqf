/*
 * File: fn_patrol_job.sqf
 * Author: Spoffy
 * Description goes here:
 * 	  Maintains units that are assigned to patrol. Runs as a scheduler job. Should not be called directly.
 * Params:
 * 	  None
 * Returns:
 *    None
 * Example usage goes here
 * 	 ["jobId", vn_mf_fnc_patrol_job, [], 5] call vn_mf_fnc_scheduler_add_job
 */

{
	private _patrolGroup = _x;
	
	//If they've got nothing to do, give them something to do.
	if (currentWaypoint _patrolGroup == count waypoints _patrolGroup) then {
		[_patrolGroup, _patrolGroup getVariable "patrolCenter", _patrolGroup getVariable "patrolRadius"] call BIS_fnc_taskPatrol;	
	};
} forEach vn_mf_patrols;