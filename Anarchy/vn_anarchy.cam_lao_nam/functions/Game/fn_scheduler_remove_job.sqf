
/*
  Author: Spoffy

  Description:
	Removes a job from the main scheduler. Note: The job will have one more run before it gets removed.

  Example Usage:
	[_jobId] call vn_an_fnc_scheduler_remove_job

  Parameters:
	_jobId - Id of job to remove

  Returns:
	Boolean - whether job was successfully removed
*/

params ["_jobId"];

private _job = [_jobId] call vn_an_fnc_scheduler_get_job; 

if (isNull _job) exitWith {
	false
};


//This should be enough to make the scheduler remove it after the next run.
//Also gives the job a chance to clean itself up on the next run.
_job setVariable ["removeFromScheduler", true];
true