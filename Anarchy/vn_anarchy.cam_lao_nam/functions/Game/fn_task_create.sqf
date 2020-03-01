/*
  Author: Aaron Clark and Spoffy

  Description:
	Creates a task that's defined by the gamemode config.

  Example Usage:
	['task_1'] call vn_an_fnc_task_create;
	['task_1'] call vn_an_fnc_task_create;
	['task_1', 'zone_ba_ria', ['pos', [0,0,0]]] call vn_an_fnc_task_create;

  Returns:
	[taskClass, taskDataStore, scriptHandle] if task created
	[] if not

  Parameter(s):
*/
params [
	"_class",			 	// 0: STRING - Current Task
	"_taskMarker",				// 1: zone to create the task in
	["_parameters", []],    // 2: Extra parameters passed to the task at runtime
	["_taskgroupID","NA"],	// 3: groupID that invoked the task
	["_targetGroupIds", []] // 4: Teams to send task to, all groups if blank
];

private _accepted_groups = getArray(missionConfigFile >> "gamemode" >> "settings" >> "groups" ) apply {_x select 0}; // ["MikeForce","SpikeTeam","ACAV","GreenHornets"]

private _taskConfig = (missionConfigFile >> "gamemode" >> "tasks" >> _class);
if (isClass _taskConfig) then
{
	private _taskname = getText (_taskConfig >> "taskname");
	private _taskformatdata = getText (_taskConfig >> "taskformatdata");
	private _taskdesc = getText (_taskConfig >> "taskdesc");
	private _taskgroups = getArray (_taskConfig >> "taskgroups");
	private _requestgroups = getArray (_taskConfig >> "requestgroups");
	private _tasktype = getText (_taskConfig >> "tasktype");
	//taskScript is expected to be code, that returns the code we actually want to run.
	private _taskScript = call compile getText (_taskConfig >> "taskScript");
	private _taskCategory = getText (_taskConfig >> "taskcategory");

	private _taskClass = configName _taskConfig;

	if !(_targetGroupIds isEqualTo []) then {
		_taskGroups = _taskGroups select {_x in _targetGroupIds};
	};

	private _targetGroups = [];
	private _grp = grpNull;
	{
		_grp = missionNamespace getVariable [_x,grpNull];
		if (!isNull _grp) then
		{
			_targetGroups pushBackUnique _grp;
		};
	} forEach _taskgroups;

	private _isAllowed = true;
	if !(_requestgroups isEqualTo []) then
	{
		_isAllowed = false;

		{
			if (_taskgroupID in _accepted_groups) exitWith {_isAllowed = true;};
		} forEach _requestgroups;
	};

	diag_log format["_isAllowed %1 _targetGroups %2 taskClass %3 _taskgroupID %4 _requestgroups %5",_isAllowed,_targetGroups, _taskClass, _taskgroupID, _requestgroups];
	if (_isAllowed) exitWith
	{
		//Use the counter to make sure our task ID is unique.
		vn_an_taskCounter = vn_an_taskCounter + 1;
		private _taskFrameworkId = format ["%1:%2", vn_an_taskCounter, _taskClass];
		//Copy task details into the datastore.
		private _taskDataStore = false call vn_an_fnc_create_namespace;
		_taskDataStore setVariable ["taskId", _taskFrameworkId];
		_taskDataStore setVariable ["taskClass", _taskClass];
		_taskDataStore setVariable ["taskRequestedBy", _taskGroupId];
		_taskDataStore setVariable ["taskConfig", _taskConfig];
		_taskDataStore setVariable ["taskSubtasks", []];
		_taskDataStore setVariable ["taskGroups", _taskGroups];
		_taskDataStore setVariable ["taskMarker", _taskMarker];
		_taskDataStore setVariable ["taskCategory", _taskCategory];

		//Load the additional parameters into the task data store.
		{
			//Do a validity check on each parameter. We can do away with this if it's a performance issue.
			if (_x isEqualType [] && {count _x == 2} && {(_x select 0) isEqualType ""}) then {
				_taskDataStore setVariable [_x select 0, _x select 1];
			} else {
				diag_log format ["Invalid format passed to task_create for %1", _taskClass];
			};
		} forEach _parameters;

		//Format the name, allowing it to use anything from the task data store.
		//We need to do it this way, as concatenating arrays has issues when the format string returns nil/
		private _formatData = _taskDataStore call compile _taskformatdata;
		private _nameFormatParams = [_taskName];
		_nameFormatParams append _formatData;
		private _formattedTaskName = format _nameFormatParams;

		private _descFormatParams = [_taskDesc];
		_descFormatParams append _formatData;
		private _formattedTaskDesc = format _descFormatParams;


		[_targetGroups, _taskFrameworkId, [_formattedTaskDesc,_formattedTaskName,_taskmarker], objNull,"AUTOASSIGNED" , 1, true, _tasktype, true] call BIS_fnc_taskCreate;

		// save last created task of each type
		["SET", ("last_" + _taskCategory), _taskClass] call vn_an_fnc_hive;

		private _taskEntry = [_taskFrameworkId, _taskDataStore];

		//Arrays are a terrible way to store data. They're brittle, and difficult to change.
		//That's why anything that isn't these should go in the taskDataStore.
		//So I repeat - DO NOT ADD THINGS TO THIS ARRAY. Add them to the data store instead.
		vn_an_tasks pushBack _taskEntry;
		[_taskFrameworkId, _taskScript, [_taskDataStore], 5] call vn_an_fnc_scheduler_add_job;
		["taskCreated", _taskDataStore] call vn_an_fnc_event_dispatch;
		_taskEntry
	};
	[]
};
