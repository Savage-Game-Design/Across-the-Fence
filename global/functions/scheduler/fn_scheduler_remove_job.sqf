/*
	File: fn_scheduler_remove_job.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Removes a job from the main scheduler. Note: The job will have one more run before it gets removed.
	
	Parameter(s):
		_jobId - Id of job to remove [String]
	
	Returns:
		Whether job was successfully removed [Boolean]
	
	Example(s):
		[_jobId] call para_g_fnc_scheduler_remove_job
*/

params ["_jobId"];

private _job = [_jobId] call para_g_fnc_scheduler_get_job; 

if (isNull _job) exitWith {
	false
};

//This should be enough to make the scheduler remove it after the next run.
//Also gives the job a chance to clean itself up on the next run.
_job setVariable ["removeFromScheduler", true];

true