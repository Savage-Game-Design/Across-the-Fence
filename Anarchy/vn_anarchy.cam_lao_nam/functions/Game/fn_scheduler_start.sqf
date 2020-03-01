/*
  Author: Aaron Clark and Spoffy

  Description:
	Main scheduler. Handles frequent, repetitive, in-expensive tasks that don't need to be spawn'd.
	Nothing scheduled here should ever take a long time to run - as it'll block the scheduler doing anything.

	Tasks are a namespace with the following variables set:
		code - Code to run each tick
		tickDelay - Delay between ticks
		startTime - When the job was added to the scheduler

	These variables are added in the scheduler

		lastTickTime - last time the job was run
		removeFromScheduler - set when the task wants to be removed.


  Example Usage:
	0 call vn_an_fnc_scheduler_start;

  Returns:
	NOTHING

*/

vn_an_schedulerHandle = [] spawn {
	vn_an_runScheduler = true;

	while {vn_an_runScheduler} do
	{
		private _tickTime = diag_tickTime;
		private _toBeRemoved = [];
		{
			//_schedulerCurrentJob is designed to be accessible from within the code of scheduled jobs.
			//Do not change it without changing all references to it in the project.
			_x params ["_jobId", "_schedulerCurrentJob"];
			//Most defaults shouldn't be used here, but better safe than crash the scheduler.
			private _code = _schedulerCurrentJob getVariable ["code", {}];
			private _parameters = _schedulerCurrentJob getVariable ["parameters", []];
			private _tickDelay = _schedulerCurrentJob getVariable ["tickDelay", 5];
			private _startTime = _schedulerCurrentJob getVariable ["startTime", 0];
			private _lastTickTime = _schedulerCurrentJob getVariable ["lastTickTime", 0];

			if ((_tickTime - _lastTickTime) > _tickDelay) then
			{
				//If debug scheduler is enabled, dump the jobs to the log file.
				if (!isNil "debugScheduler") then {
					diag_log format ["SCHEDULER: Job running - %1", _jobId];
				};

				_schedulerCurrentJob setVariable ["lastTickTime", _tickTime];

				_parameters call _code;

				if (_schedulerCurrentJob getVariable ["removeFromScheduler", false]) then
				{
					_toBeRemoved pushBack _foreachindex;
				};
			};
		} forEach vn_an_schedulerJobs;
		// reverse array and remove from last to first
		reverse _toBeRemoved;
		{
			//Delete the namespace used by the job, so we don't get a bunch lingering around as the mission runs.
			private _job = vn_an_schedulerJobs select _x select 1;
			_job call vn_an_fnc_delete_namespace;
			//Now just remove the job entry from the scheduler.
			vn_an_schedulerJobs deleteAt _x;
		} forEach _toBeRemoved;
		uiSleep 0.1;
	};
};
