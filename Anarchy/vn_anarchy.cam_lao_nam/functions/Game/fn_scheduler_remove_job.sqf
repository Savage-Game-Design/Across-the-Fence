
/*
  Author: Spoffy

  Description:
	Removes a job from the main scheduler. Note: The job will have one more run before it gets removed.

  Example Usage:
	[_jobId] call vn_mf_fnc_scheduler_remove_job

  Parameters:
	_jobId - Id of job to remove

  Returns:
	Boolean - whether job was successfully removed
*/

params ["_jobId"];

private _jobPos = vn_mf_schedulerJobs findIf {_x select 0 == _jobId};

if (_jobPos < 0) exitWith {
	false
};

private _job = (vn_mf_schedulerJobs select _jobPos) select 1;

//This should be enough to make the scheduler remove it after the next run.
//Also gives the job a chance to clean itself up on the next run.
_job setVariable ["removeFromScheduler", true];