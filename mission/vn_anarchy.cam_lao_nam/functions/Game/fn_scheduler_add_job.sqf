/*
  Author: Aaron Clark and Spoffy

  Description:
	Adds a job to the main scheduler.

  Example Usage:
	[_code, _tickDelay] call vn_an_fnc_scheduler_add_job

  Parameters:
	_code - Code to run in the scheduler
	_tickDelay - Minimum delay in seconds between runs.

  Returns:
	NOTHING
*/

params ["_jobId", "_code", "_parameters", "_tickDelay", ["_iterationsToRun", -1]];

private _job = false call vn_an_fnc_create_namespace;

_job setVariable ["jobId", _jobId];
_job setVariable ["code", _code];
_job setVariable ["tickDelay", _tickDelay];
_job setVariable ["startTime", call vn_an_fnc_save_time_elapsed];
_job setVariable ["parameters", _parameters];
_job setVariable ["remainingIterations", _iterationsToRun];

vn_an_schedulerJobs pushBack [_jobId, _job];
