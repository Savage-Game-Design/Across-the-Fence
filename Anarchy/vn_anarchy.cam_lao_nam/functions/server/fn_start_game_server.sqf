diag_log "VN: Server Init started";

// restart every time
// ["CLEAR"] call vn_mf_fnc_hive;

if (isNil "vn_mf_gamestarting") then
{
	vn_mf_buildings = []; // todo restore from db init for now

	vn_mf_gamestarting = true;

	private _gamemode_config = (missionConfigFile >> "gamemode");

	param_ai_quantity = ["ai_quantity", 1] call BIS_fnc_getParamValue;

	// setup game optimizations server side
	setviewdistance (getNumber(_gamemode_config >> "performance" >> "setviewdistance"));
	setobjectviewdistance (getArray(_gamemode_config >> "performance" >> "setobjectviewdistance")); // this also controls ai target range
	setterraingrid (getNumber(_gamemode_config >> "performance" >> "setterraingrid"));
	(getArray(_gamemode_config >> "performance" >> "enableenvironment")) params ["_ambientlife","_ambientsound"];
	enableenvironment [[false,true] select _ambientlife,[false,true] select _ambientsound];

	// start scheduler
	vn_mf_schedulerJobs = [];
	0 call vn_mf_fnc_scheduler_start;
	0 spawn vn_mf_fnc_scheduler_monitor;

	// start the event dispatcher, so anything relying on events can fire.
	call vn_mf_fnc_event_subsystem_init;

	// creates and initialize groups and duty officers
	call vn_mf_fnc_group_init;
	//Initialise task list
	vn_mf_tasks = [];
	vn_mf_taskCompletionLog = [];
	//Counts the number of tasks that have been created, to let us have unique IDs.
	vn_mf_taskCounter = 0;

	//Build the lists of secondary tasks, so we can create them later.
	//Tasks without a marker aren't valid secondary tasks.
	vn_mf_secondaryTaskConfigs = "getText (_x >> 'taskCategory') == 'SEC' && getText (_x >> 'taskname') != ''" configClasses (missionConfigFile >> "gamemode" >> "tasks");

	//Create a lookup for tasks by zone and team
	vn_mf_secondaryTasksBySide = false call vn_mf_fnc_create_namespace;
	vn_mf_secondaryTasksBySide setVariable ["MikeForce", []];
	vn_mf_secondaryTasksBySide setVariable ["SpikeTeam", []];
	vn_mf_secondaryTasksBySide setVariable ["GreenHornets", []];
	vn_mf_secondaryTasksBySide setVariable ["ACAV", []];

	{
		private _taskConfig = _x;
		//Add the task to appropriate team arrays for the zone
		{
			vn_mf_secondaryTasksBySide getVariable _x pushBack configName _taskConfig;
		} forEach (getArray (_taskConfig >> 'taskGroups'));
	} forEach (vn_mf_secondaryTaskConfigs);

	// load objects while retaining state and variables
	call vn_mf_fnc_spawn_objects;

	// load zone progress
	call vn_mf_fnc_zone_init;

	// init buildables type arrays
	private _buildables_config = (_gamemode_config >> "buildables");
	private _classes = "isClass _x" configClasses (_buildables_config);
	private _types = [];
	{
		private _buildable_type = getText(_x >> "type");
		if !(_buildable_type in _types) then
		{
			_types pushBack _buildable_type;
			missionNamespace setVariable [format["vn_mf_%1",_buildable_type],[]];
		};
	} forEach _classes;

	private _vars_config = (_gamemode_config >> "vars" >> "buildables");
	private _public_vars = getArray(_vars_config >> "publicvars");

	// spawn buildables
	(["GET", "buildables", []] call vn_mf_fnc_hive) params ["",["_buildables",[]]];
	{
		_x params ["_class","_pos","_vectors","_vars","_type"];
		// create building at saved position and angle
		_object = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"];
		_object setVectorDirAndUp _vectors;
		_object setPosWorld _pos;

		// restore vars
		if !(_vars isEqualTo []) then
		{
			{
				_x params ["_varname","_vardata"];
				if (_varname in _public_vars) then
				{
					_object setVariable [_varname,_vardata,true];
				}
				else
				{
					_object setVariable [_varname,_vardata];
				};

			} forEach _vars;
		};

		// restore any agents
		_agents = [];
		private _object_class = getText(_buildables_config >> _class >> "final_state" >> "object_class");
		if (_object_class isEqualTo _class) then
		{
			private _agents_cfg = getArray(_buildables_config >> _class >> "agents");
			{
				_pos = _object buildingPos (_foreachindex + 1);
				if !(_pos isEqualTo [0,0,0]) then
				{
					private _agent = createAgent [_x, _pos, [], 0, "NONE"];
					_agent enableSimulationGlobal false;
					_agent disableAI "ALL";
					_agent allowDamage false;
					_agents pushBack _agent;
				};
			} forEach _agents_cfg;
			_object setVariable ["vn_mf_agents", _agents];
		};

		// add to types array for finding buildables of a type
		private _typename = format["vn_mf_%1",_type];
		private _objects = missionNamespace getVariable [_typename, []];
		_objects pushBack _object;
		missionNamespace setVariable [_typename, _objects];

		// add to array for tracking
		vn_mf_buildings pushBack _object;
	} forEach _buildables;

	//Example unit types. Should be made more dynamic as the gamemode progresses.
	unit_civilian = "uns_civilian1";
	units_vc_basic = ["vn_o_men_vc_local_03","vn_o_men_vc_local_03","vn_o_men_vc_local_12"];
	units_vc_officer = ["vn_o_men_vc_local_01"];
	units_vc_smg = ["vn_o_men_vc_local_06","vn_o_men_vc_local_05","vn_o_men_vc_local_04"];
	units_vc_marksman = ["vn_o_men_vc_local_10"];
	units_vc_medic = ["vn_o_men_vc_local_08"];
	units_vc_grenadier = ["vn_o_men_vc_local_07"];
	units_vc_at = ["vn_o_men_vc_local_14"];
	units_vc_mg = ["vn_o_men_vc_local_11"];

	units_sog_teamleader = ["vn_b_men_sog_01", "vn_b_men_sog_13"];
	units_sog_rto = ["vn_b_men_sog_02", "vn_b_men_sog_14"];
	units_sog_medic = ["vn_b_men_sog_03", "vn_b_men_sog_15"];
	units_sog_scout = ["vn_b_men_sog_09", "vn_b_men_sog_19"];
	units_sog_grenadier = ["vn_b_men_sog_07", "vn_b_men_sog_11"];
	units_sog_machinegunner = ["vn_b_men_sog_06", "vn_b_men_sog_16", "vn_b_men_sog_18"];

	vehicles_nva_helis = ["uns_Mi8T_VPAF"];
	vehicles_nva_planes = ["uns_an2_cas"];

	jungleTraps = [
	    "uns_tripwire_punj1",
	    "uns_tripwire_punj2",
	    "uns_tripwire_punj3",
	    "uns_tripwire_punj4"
	];

	enemyAPMines = [
	    "uns_mine_md82"
	];

	enemyATMines = [
	    "uns_mine_tm57"
	];

	friendlyAPMines = [
	    "uns_mine_m14",
	    "uns_mine_m16"
	];

	friendlyATMines = [
	    "uns_mine_t59"
	];

	incendiaryMines = [
	    "uns_mine_xm54"
	];

	// start patrol subsystem
	[] call vn_mf_fnc_patrol_subsystem_init;

	// start cleanup subsystem
	[] call vn_mf_fnc_cleanup_subsystem_init;

	// flag server as ready
	missionNamespace setVariable ["vn_mf_server_ready", true, true];

};


diag_log "VN: Server Init finished";
