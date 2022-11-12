/*
	File: fn_scheduler_get_job.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Retrieves a job from the scheduler given its ID
	
	Parameter(s):
		_jobId - ID of the job as it was registered in the scheduler [String]
	
	Returns:
		Job namespace or locationNull on failure [Location]
	
	Example(s):
		["myJobId"] call para_g_fnc_scheduler_get_job
*/

params ["_jobId"];


private _jobPos = para_l_schedulerJobs findIf {_x select 0 == _jobId};

if (_jobPos < 0) exitWith {
	locationNull
};

para_l_schedulerJobs select _jobPos select 1