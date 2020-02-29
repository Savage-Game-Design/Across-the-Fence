class primary_1 : simple_task_system_task
{
	taskcategory = "PRI";
	taskmarker = "";
	tasktitle = "Build <UNKNOWN> Checkpoint";
	taskname = "Build <UNKNOWN> Checkpoint";
	taskdesc = "Build checkpoints to control the zone";
	tasktype = "walk";
	taskimage = "vn\missions_f_vietnam\data\img\mikeforce\p\vn_ui_mf_task_p1.jpg";
	rankpoints = 0;
	taskprogress = 10;

	//Data for the script to use to customise behaviour
	class parameters {
		initialSubtasks[] = {"setup_checkpoints"};
	};

	//Data for subtasks. These are specific to the script.
	class setup_checkpoints {
		taskname = "Go to Zone";
		taskdesc = "Head to <UNKNOWN>, in order to establish checkpoints";

		//Data to customise
		//These are specific to each subtask for each mission - see mission documentation.
		class parameters {
			Init = "";
			CanRun = "!((allUnits inAreaArray (_taskDataStore getVariable 'taskMarker')) select {alive _x && side _x == west} isEqualTo [])";
			RunAtRegularIntervals = "_hasSucceeded = true";
			FailureCondition = "false";
			OnFailure = "";
			OnSuccess = "";
			NextSubtasks[] = {"build_checkpoint"};
			Pos[] = {"marker", ''};
		};
	};

	class build_checkpoint {
		taskname = "Build Checkpoint";
		taskdesc = "Build the checkpoint in <UNKNOWN>.";

		//Data to customise
		//These are specific to each subtask for each mission - see mission documentation.
		class parameters {
			Init = "";
			CanRun = "!((vn_mf_checkpoints inAreaArray (_taskDataStore getVariable 'taskMarker')) select {alive _x} isEqualTo [])";
			RunAtRegularIntervals = "_hasSucceeded = true";
			FailureCondition = "false";
			OnFailure = "";
			OnSuccess = "private _nextTask = selectRandom ['primary_2a', 'primary_2b']; [_nextTask, ''] call vn_mf_fnc_task_create; [_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete;";
			NextSubtasks[] = {};
			Pos[] = {"marker", ''};
		};
	};
};

class primary_2a : simple_task_system_task
{
	taskcategory = "PRI";
	taskmarker = "";
	tasktitle = "Deliver Supplies";
	taskname = "Deliver Supplies";
	taskdesc = "Deliver vital supplies to the zone";
	tasktype = "box";
	taskimage = "vn\missions_f_vietnam\data\img\mikeforce\p\vn_ui_mf_task_p2a.jpg";
	rankpoints = 0;
	taskprogress = 5;

	//Data for the script to use to customise behaviour
	class parameters {
		initialSubtasks[] = {"take_supplies"};
	};

	//Data for subtasks. These are specific to the script.
	class take_supplies {
		taskname = "Take Supplies";
		taskdesc = "Deliver vital supplies to the zone";

		//Data to customise
		//These are specific to each subtask for each mission - see mission documentation.
		class parameters {
			Init = "_subtask setVariable ['box', createVehicle ['uns_box1', _subtask getVariable 'subtaskPos', [], 0, 'NONE']];";
			CanRun = "!((allUnits inAreaArray [getPos (_subtask getVariable 'box'),5,5,0,false]) select {alive _x && side _x == west && isPlayer _x} isEqualTo [])";
			RunAtRegularIntervals = "(_subtask getVariable 'box') call vn_mf_fnc_delete_building; _hasSucceeded = true";
			FailureCondition = "false";
			OnFailure = "";
			OnSuccess = "";
			NextSubtasks[] = {"deliver_supplies"};
			Pos[] = {"marker", "respawn_west_acav"};
		};
	};

	class deliver_supplies {
		taskname = "Deliver Supplies";
		taskdesc = "Deliver vital supplies to the zone";

		//Data to customise
		//These are specific to each subtask for each mission - see mission documentation.
		class parameters {
			Init = "";
			CanRun = "!((allUnits inAreaArray [(_subtask getVariable 'subtaskPos'),15,15,0,false]) select {alive _x && side _x == west} isEqualTo [])";
			RunAtRegularIntervals = "[vn_mf_obj_deliver_1,'Land_Barracks_01_grey_F'] call vn_mf_fnc_swap_building; _hasSucceeded = true;";
			FailureCondition = "false";
			OnFailure = "";
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; ['primary_3', ''] call vn_mf_fnc_task_create";
			NextSubtasks[] = {};
			Pos[] = {"random", {{""}, {"water"}}};
		};
	};
};

class primary_2b : simple_task_system_task
{
	taskcategory = "PRI";
	taskmarker = "";
	tasktitle = "Deliver Aid";
	taskname = "Deliver Aid";
	taskdesc = "Deliver vital supplies to the zone";
	tasktype = "box";
	taskimage = "vn\missions_f_vietnam\data\img\mikeforce\p\vn_ui_mf_task_p2b.jpg";
	rankpoints = 0;
	taskprogress = 5;

	//Data for the script to use to customise behaviour
	class parameters {
		initialSubtasks[] = {"take_supplies"};
	};

	//Data for subtasks. These are specific to the script.
	class take_supplies {
		taskname = "Take Medical Supplies";
		taskdesc = "Deliver vital supplies to the zone";

		//Data to customise
		//These are specific to each subtask for each mission - see mission documentation.
		class parameters {
			Init = "_subtask setVariable ['box', createVehicle ['uns_box1', _subtask getVariable 'subtaskPos', [], 0, 'NONE']];";
			CanRun = "!((allUnits inAreaArray [getPos (_subtask getVariable 'box'),5,5,0,false]) select {alive _x && side _x == west} isEqualTo [])";
			RunAtRegularIntervals = "(_subtask getVariable 'box') call vn_mf_fnc_delete_building; _hasSucceeded = true";
			FailureCondition = "false";
			OnFailure = "";
			OnSuccess = "";
			NextSubtasks[] = {"build_aid_post"};
			Pos[] = {"marker", "respawn_west_acav"};
		};
	};

	class build_aid_post {
		taskname = "Build Aid Post";
		taskdesc = "Deliver vital supplies to the zone";

		//Data to customise
		//These are specific to each subtask for each mission - see mission documentation.
		class parameters {
			Init = "";
			CanRun = "!((vn_mf_aid inAreaArray [(_subtask getVariable 'subtaskPos'),50,50,0,false]) select {alive _x} isEqualTo [])";
			RunAtRegularIntervals = "_hasSucceeded = true";
			FailureCondition = "false";
			OnFailure = "";
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; ['primary_3', ''] call vn_mf_fnc_task_create";
			NextSubtasks[] = {};
			Pos[] = {"random", {{""}, {"water"}}};
		};
	};
};

class primary_3 : simple_task_system_task
{
	taskcategory = "PRI";
	taskmarker = "";
	tasktitle = "Patrol";
	taskname = "Patrol Zone";
	taskdesc = "Patrol the zone and gather intelligence";
	tasktype = "walk";
	taskimage = "vn\missions_f_vietnam\data\img\mikeforce\p\vn_ui_mf_task_p3.jpg";
	rankpoints = 0;
	taskprogress = 10;

	//The script called when the task is created.
	taskScript = "vn_mf_fnc_simple_task_system";

	//Data for the script to use to customise behaviour
	class parameters {
		initialSubtasks[] = {"patrol_area"};
	};

	//Data for subtasks. These are specific to the script.
	class patrol_area {
		taskname = "Patrol the Area";
		taskdesc = "Patrol the area to gather intelligence";

		//Data to customise
		//These are specific to each subtask for each mission - see mission documentation.
		class parameters {
			Init = "";
			CanRun = "!((allUnits inAreaArray [(_subtask getVariable 'subtaskPos'),50,50,0,false]) select {alive _x && side _x == west} isEqualTo [])";
			RunAtRegularIntervals = "_hasSucceeded = true";
			FailureCondition = "false";
			OnFailure = "";
			OnSuccess = "";
			NextSubtasks[] = {"patrol_area_2"};
			Pos[] = {"random",{{""},{"water"}}};
		};
	};

	class patrol_area_2 {
		taskname = "Patrol the Area";
		taskdesc = "Patrol the area to gather intelligence";

		//Data to customise
		//These are specific to each subtask for each mission - see mission documentation.
		class parameters {
			Init = "";
			CanRun = "!((allUnits inAreaArray [(_subtask getVariable 'subtaskPos'),50,50,0,false]) select {alive _x && side _x == west} isEqualTo [])";
			RunAtRegularIntervals = "_hasSucceeded = true";
			FailureCondition = "false";
			OnFailure = "";
			OnSuccess = "";
			NextSubtasks[] = {"talk_to_civilian"};
			Pos[] = {"random",{{""},{"water"}}};
		};
	};

	class talk_to_civilian {
		taskname = "Talk to Civilian";
		taskdesc = "Patrol the area to gather intelligence";

		//Data to customise
		//These are specific to each subtask for each mission - see mission documentation.
		class parameters {
			//Got some global state in here still :(
			Init = "_subtask setVariable ['civilian', [_subtask getVariable 'subtaskPos','vn_mf_task_civ_2'] call vn_mf_fnc_spawn_civilian]; _subtask setVariable ['subtaskPos', getPos (_subtask getVariable 'civilian')]";
			CanRun = "missionNamespace getVariable ['vn_mf_task_civ_2',false]";
			RunAtRegularIntervals = "private _subtaskPos = (_subtask getVariable 'subtaskPos'); vn_mf_task_enemy_grp_p3_3 = [[_subtaskPos,10,10,0,false],[[[_subtaskPos, 150]],[[_subtaskPos, 100]]] call BIS_fnc_randomPos] call vn_mf_fnc_spawn_enemy_units; _hasSucceeded = true;";
			FailureCondition = "!(alive (_subtask getVariable 'civilian'))";
			OnFailure = "";
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; private _nextTask = selectRandom ['primary_4a', 'primary_4b']; [_nextTask, ''] call vn_mf_fnc_task_create;";
			NextSubtasks[] = {};
			Pos[] = {"random",{{""},{"water"}}};
		};
	};
};

// p4a Locate and destroy
class primary_4a : simple_task_system_task
{
	taskcategory = "PRI";
	taskmarker = "";
	tasktitle = "Destroy";
	taskname = "Destroy Bunker";
	taskdesc = "Locate and destroy enemy bunker";
	tasktype = "destroy";
	taskimage = "vn\missions_f_vietnam\data\img\mikeforce\p\vn_ui_mf_task_p4a.jpg";
	rankpoints = 0;
	taskprogress = 5;

	//Data for the script to use to customise behaviour
	class parameters {
		initialSubtasks[] = {"destroy_bunker"};
	};

	//Data for subtasks. These are specific to the script.
	class destroy_bunker {
		taskname = "Locate and destroy enemy bunker";
		taskdesc = "Locate and destroy enemy bunker";

		//Data to customise
		//These are specific to each subtask for each mission - see mission documentation.
		class parameters {
			Init = "['Land_vn_b_trench_firing_05', [[[_subtask getVariable 'subtaskPos', 50]],[[_subtask getVariable 'subtaskPos', 25],'water']] ,'vn_mf_rnd_destroy_1'] call vn_mf_fnc_spawn_object;";
			CanRun = "!(alive vn_mf_rnd_destroy_1)";
			RunAtRegularIntervals = "_hasSucceeded = true;";
			FailureCondition = "false";
			OnFailure = "";
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; ['primary_5', ''] call vn_mf_fnc_task_create;";
			NextSubtasks[] = {};
			Pos[] = {"random",{{""},{"water"}}};
		};
	};
};


// p4b Kill the VC tax collector to protect the zone
class primary_4b : simple_task_system_task
{
	taskcategory = "PRI";
	taskmarker = "";
	tasktitle = "Kill Tax Collector";
	taskname = "Kill Tax Collector";
	taskdesc = "Kill the VC tax collector to protect the zone.";
	tasktype = "kill";
	taskimage = "vn\missions_f_vietnam\data\img\mikeforce\p\vn_ui_mf_task_p4b.jpg";
	rankpoints = 0;
	taskprogress = 5;

	//Data for the script to use to customise behaviour
	class parameters {
		initialSubtasks[] = {"find_tax_collector"};
	};

	//Data for subtasks. These are specific to the script.
	class find_tax_collector {
		taskname = "Find Tax Collector";
		taskdesc = "Kill the VC tax collector to protect the zone";

		//Data to customise
		//These are specific to each subtask for each mission - see mission documentation.
		class parameters {
			Init = "private _pos = _subtask getVariable 'subtaskPos'; vn_mf_task_enemy_grp_4 = [[_pos,1,1,0,false],[[[_pos, 15]],[[_pos, 10]]] call BIS_fnc_randomPos] call vn_mf_fnc_spawn_enemy_units;";
			CanRun = "!((allUnits inAreaArray [(_subtask getVariable 'subtaskPos'),20,20,0,false]) select {alive _x && side _x == west} isEqualTo [])";
			RunAtRegularIntervals = "(vn_mf_task_enemy_grp_4) addWaypoint [_subtask getVariable 'subtaskPos', 0]; _hasSucceeded = true;";
			FailureCondition = "isNull (vn_mf_task_enemy_grp_4)";
			OnFailure = "[_taskDataStore, 'FAILED'] call vn_mf_fnc_task_complete; ['primary_7', ''] call vn_mf_fnc_task_create;";
			OnSuccess = "";
			NextSubtasks[] = {"kill_tax_collector"};
			Pos[] = {"random",{{""},{"water"}}};
		};
	};

	class kill_tax_collector {
		taskname = "Kill Tax Collector";
		taskdesc = "Kill the tax collector to protect the zone";

		class parameters {
			Init = "";
			CanRun = "[[_subtask getVariable 'subtaskPos',200,200,0,false]] call vn_mf_fnc_check_enemy_units_alive";
			RunAtRegularIntervals = "_hasSucceeded = true;";
			FailureCondition = "isNull (vn_mf_task_enemy_grp_4)";
			OnFailure = "[_taskDataStore, 'FAILED'] call vn_mf_fnc_task_complete; ['primary_7', ''] call vn_mf_fnc_task_create;";
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; ['primary_5', ''] call vn_mf_fnc_task_create;";
			NextSubtasks[] = {};
			//This isn't going to work.
			Pos[] = {"group", "vn_mf_task_enemy_grp_4"};
		};
	};
};

class primary_5 : simple_task_system_task
{
	taskcategory = "PRI";
	taskmarker = "";
	tasktitle = "Build School";
	taskname = "Build School";
	taskdesc = "Build a school hut at the zone";
	tasktype = "box";
	taskimage = "vn\missions_f_vietnam\data\img\mikeforce\p\vn_ui_mf_task_p5.jpg";
	rankpoints = 0;
	taskprogress = 10;

	//Data for the script to use to customise behaviour
	class parameters {
		initialSubtasks[] = {"take_building_supplies"};
	};

	//Data for subtasks. These are specific to the script.
	class take_building_supplies {
		taskname = "Take Building Supplies";
		taskdesc = "Collect the building supplies. (Currently, just walk near them)";

		//Data to customise
		//These are specific to each subtask for each mission - see mission documentation.
		class parameters {
			Init = "vn_mf_rnd_object_2 = ['uns_box1', [0,0,0]] call vn_mf_fnc_create_vehicle; vn_mf_rnd_object_2 setPos (_subtask getVariable 'subtaskPos')";
			CanRun = "!((allUnits inAreaArray [getPos vn_mf_rnd_object_2,5,5,0,false]) select {alive _x && side _x == west} isEqualTo [])";
			RunAtRegularIntervals = "vn_mf_rnd_object_2 call vn_mf_fnc_delete_building; _hasSucceeded = true;";
			FailureCondition = "false";
			OnFailure = "";
			OnSuccess = "";
			NextSubtasks[] = {"build_school"};
			Pos[] = {"random",{{""},{"water"}}};
		};
	};

	class build_school {
		taskname = "Build School";
		taskdesc = "Build a school hut at the zone";

		class parameters {
			Init = "";
			CanRun = "!((vn_mf_schools inAreaArray (_taskDataStore getVariable 'taskMarker')) select {alive _x} isEqualTo [])";
			RunAtRegularIntervals = "_hasSucceeded = true;";
			FailureCondition = "";
			OnFailure = "";
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; private _nextTask = selectRandom ['primary_6a', 'primary_6b']; [_nextTask, ''] call vn_mf_fnc_task_create;";
			NextSubtasks[] = {};
			//This isn't going to work.
			Pos[] = {"marker", ''};
		};
	};
};

// Defend the zone from the VC attack
class primary_6a : simple_task_system_task
{
	taskcategory = "PRI";
	taskmarker = "";
	tasktitle = "Defend Village";
	taskname = "Defend Village";
	taskdesc = "Patrol the zone and gather intelligence";
	tasktype = "defend";
	taskimage = "vn\missions_f_vietnam\data\img\mikeforce\p\vn_ui_mf_task_p6a.jpg";
	rankpoints = 0;
	taskprogress = 5;

	//Data for the script to use to customise behaviour
	class parameters {
		initialSubtasks[] = {"go_to_zone"};
	};

	//Data for subtasks. These are specific to the script.
	class go_to_zone {
		taskname = "Go to the Village";
		taskdesc = "Defend the village from the VC attack";

		//Data to customise
		//These are specific to each subtask for each mission - see mission documentation.
		class parameters {
			Init = "vn_mf_task_civ_obj_p6 = [_subtask getVariable 'subtaskPos','vn_mf_task_civ_p6'] call vn_mf_fnc_spawn_civilian; _subtask setVariable ['subtaskPos', getPos vn_mf_task_civ_obj_p6];";
			CanRun = "!((allUnits inAreaArray [_subtask getVariable 'subtaskPos',20,20,0,false]) select {alive _x && side _x == west} isEqualTo [])";
			RunAtRegularIntervals = "_hasSucceeded = true";
			FailureCondition = "false";
			OnFailure = "";
			OnSuccess = "";
			NextSubtasks[] = {"defend_village"};
			Pos[] = {"random",{{""},{"water"}}};
		};
	};

	//Data for subtasks. These are specific to the script.
	class defend_village {
		taskname = "Defend the Village";
		taskdesc = "Defend the village from the VC attack";

		//Data to customise
		//These are specific to each subtask for each mission - see mission documentation.
		class parameters {
			Init = "vn_mf_task_enemy_grp_p6a = [[(_subtask getVariable 'subtaskPos'),50,50,0,false],[[[(_subtask getVariable 'subtaskPos'), 150]],[[(_subtask getVariable 'subtaskPos'), 100]]] call BIS_fnc_randomPos] call vn_mf_fnc_spawn_enemy_units; vn_mf_task_enemy_grp_p6a addWaypoint [(_subtask getVariable 'subtaskPos'), 0];";
			CanRun = "[[(_subtask getVariable 'subtaskPos'),200,200,0,false]] call vn_mf_fnc_check_enemy_units_alive";
			RunAtRegularIntervals = "_hasSucceeded = true";
			FailureCondition = "false";
			OnFailure = "";
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; ['primary_7', ''] call vn_mf_fnc_task_create;";
			NextSubtasks[] = {};
			Pos[] = {"object", "vn_mf_task_civ_obj_p6"};
		};
	};
};

// Ambush the VC recruiters
class primary_6b : simple_task_system_task
{
	taskcategory = "PRI";
	taskmarker = "";
	tasktitle = "Ambush VC";
	taskname = "Ambush VC";
	taskdesc = "Ambush the VC recruiters";
	tasktype = "attack";
	taskimage = "vn\missions_f_vietnam\data\img\mikeforce\p\vn_ui_mf_task_p6b.jpg";
	rankpoints = 0;
	taskprogress = 10;

	//Data for the script to use to customise behaviour
	class parameters {
		initialSubtasks[] = {"go_to_ambush"};
	};

	//Data for subtasks. These are specific to the script.
	class go_to_ambush {
		taskname = "Go to Ambush Location";
		taskdesc = "Go to the ambush location";

		//Data to customise
		//These are specific to each subtask for each mission - see mission documentation.
		class parameters {
			Init = "vn_mf_task_enemy_grp_p6b = [[(_subtask getVariable 'subtaskPos'),50,50,0,false],[[[(_subtask getVariable 'subtaskPos'), 150]],[[(_subtask getVariable 'subtaskPos'), 100]]] call BIS_fnc_randomPos] call vn_mf_fnc_spawn_enemy_units; vn_mf_task_civ_obj_p6 = [(_subtask getVariable 'subtaskPos'),'vn_mf_task_civ_p6'] call vn_mf_fnc_spawn_civilian;";
			CanRun = "!((allUnits inAreaArray [(_subtask getVariable 'subtaskPos'),200,200,0,false]) select {alive _x && side _x == west} isEqualTo [])";
			RunAtRegularIntervals = "_hasSucceeded = true";
			FailureCondition = "false";
			OnFailure = "";
			OnSuccess = "";
			NextSubtasks[] = {"kill_vc"};
			Pos[] = {"random",{{""},{"water"}}};
		};
	};

	class kill_vc {
		taskname = "Kill VC";
		taskdesc = "Ambush the VC recruiters";

		//Data to customise
		//These are specific to each subtask for each mission - see mission documentation.
		class parameters {
			Init = "";
			CanRun = "[[(_subtask getVariable 'subtaskPos'),200,200,0,false]] call vn_mf_fnc_check_enemy_units_alive";
			RunAtRegularIntervals = "_hasSucceeded = true";
			FailureCondition = "false";
			OnFailure = "";
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; ['primary_7', ''] call vn_mf_fnc_task_create;";
			NextSubtasks[] = {};
			Pos[] = {"group","vn_mf_task_enemy_grp_p6b"};
		};
	};

};

// Escort the elders to the meeting
class primary_7 : simple_task_system_task
{
	taskcategory = "PRI";
	taskmarker = "";
	tasktitle = "Village Meeting";
	taskname = "Village Meeting";
	taskdesc = "Escort the elders to the meeting";
	tasktype = "walk";
	taskimage = "vn\missions_f_vietnam\data\img\mikeforce\p\vn_ui_mf_task_p7.jpg";
	taskprogress = 10;

	//Data for the script to use to customise behaviour
	class parameters {
		initialSubtasks[] = {"meet_elders"};
	};

	//Data for subtasks. These are specific to the script.
	class meet_elders {
		taskname = "Meet Elders";
		taskdesc = "Escort the elders to the meeting";

		//Data to customise
		//These are specific to each subtask for each mission - see mission documentation.
		class parameters {
			Init = "vn_mf_task_civ_obj_2 = [(_subtask getVariable 'subtaskPos'),'vn_mf_task_civ_p7'] call vn_mf_fnc_spawn_civilian; _subtask setVariable['subtaskPos', getPos vn_mf_task_civ_obj_2];";
			CanRun = "missionNamespace getVariable ['vn_mf_task_civ_p7',false]";
			RunAtRegularIntervals = "_hasSucceeded = true";
			FailureCondition = "!(alive vn_mf_task_civ_obj_2)";
			OnFailure = "[_taskDataStore, 'FAILED'] call vn_mf_fnc_task_complete";
			OnSuccess = "";
			NextSubtasks[] = {"escort_elders"};
			Pos[] = {"random",{{""},{"water"}}};
		};
	};

	class escort_elders {
		taskname = "Escort Elders to Meeting";
		taskdesc = "Escort the elders to the meeting";

		//Data to customise
		//These are specific to each subtask for each mission - see mission documentation.
		class parameters {
			Init = "vn_mf_task_civ_obj_p7_2 = [(_subtask getVariable 'subtaskPos'),'vn_mf_task_civ_p7_2'] call vn_mf_fnc_spawn_civilian; vn_mf_task_civ_obj_2 setDestination [(_subtask getVariable 'subtaskPos'), 'LEADER PLANNED', true]; vn_mf_task_enemy_grp_3 = [[(_subtask getVariable 'subtaskPos'),50,50,0,false],[[[(_subtask getVariable 'subtaskPos'), 150]],[[(_subtask getVariable 'subtaskPos'), 100]]] call BIS_fnc_randomPos] call vn_mf_fnc_spawn_enemy_units;";
			CanRun = "private _pos = _subtask getVariable 'subtaskPos'; ((vn_mf_task_civ_obj_2 inArea [_pos,20,20,0,false]) && !((allUnits inAreaArray [_pos,20,20,0,false]) select {alive _x && side _x == west} isEqualTo []))";
			RunAtRegularIntervals = "vn_mf_task_enemy_grp_3 addWaypoint [(_subtask getVariable 'subtaskPos'), 0]; _hasSucceeded = true";
			FailureCondition = "!(alive vn_mf_task_civ_obj_2)";
			OnFailure = "[_taskDataStore, 'FAILED'] call vn_mf_fnc_task_complete";
			OnSuccess = "";
			NextSubtasks[] = {"defend_meeting"};
			Pos[] = {"random",{{""},{"water"}}};
		};
	};

	class defend_meeting {
		taskname = "Defend Meeting";
		taskdesc = "Escort the elders to the meeting";

		class parameters {
			Init = "";
			CanRun = "[[(_subtask getVariable 'subtaskPos'),100,100,0,false]] call vn_mf_fnc_check_enemy_units_alive";
			RunAtRegularIntervals = "_hasSucceeded = true;";
			FailureCondition = "!(alive vn_mf_task_civ_obj_2)";
			OnFailure = "[_taskDataStore, 'FAILED'] call vn_mf_fnc_task_complete";
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; private _nextTask = selectRandom ['primary_8a']; [_nextTask, ''] call vn_mf_fnc_task_create;";
			NextSubtasks[] = {};
			Pos[] = {"object", "vn_mf_task_civ_obj_2"};
		};
	};
};

class primary_8a : simple_task_system_task
{
	taskcategory = "PRI";
	taskmarker = "";
	tasktitle = "Deliver Supplies";
	taskname = "Deliver Supplies";
	taskdesc = "Deliver vital supplies to the zone";
	tasktype = "box";
	taskimage = "vn\missions_f_vietnam\data\img\mikeforce\p\vn_ui_mf_task_p2a.jpg";
	rankpoints = 0;
	taskprogress = 5;

	//Data for the script to use to customise behaviour
	class parameters {
		initialSubtasks[] = {"take_supplies"};
	};

	//Data for subtasks. These are specific to the script.
	class take_supplies {
		taskname = "Take Supplies";
		taskdesc = "Deliver vital supplies to the zone";

		//Data to customise
		//These are specific to each subtask for each mission - see mission documentation.
		class parameters {
			Init = "_subtask setVariable ['box', createVehicle ['uns_box1', _subtask getVariable 'subtaskPos', [], 0, 'NONE']];";
			CanRun = "!((allUnits inAreaArray [getPos (_subtask getVariable 'box'),5,5,0,false]) select {alive _x && side _x == west && isPlayer _x} isEqualTo [])";
			RunAtRegularIntervals = "(_subtask getVariable 'box') call vn_mf_fnc_delete_building; _hasSucceeded = true";
			FailureCondition = "false";
			OnFailure = "";
			OnSuccess = "";
			NextSubtasks[] = {"deliver_supplies"};
			Pos[] = {"marker", "respawn_west_acav"};
		};
	};

	class deliver_supplies {
		taskname = "Deliver Supplies";
		taskdesc = "Deliver vital supplies to the zone";

		//Data to customise
		//These are specific to each subtask for each mission - see mission documentation.
		class parameters {
			Init = "";
			CanRun = "!((allUnits inAreaArray [(_subtask getVariable 'subtaskPos'),15,15,0,false]) select {alive _x && side _x == west} isEqualTo [])";
			RunAtRegularIntervals = "[vn_mf_obj_deliver_1,'Land_Barracks_01_grey_F'] call vn_mf_fnc_swap_building; _hasSucceeded = true;";
			FailureCondition = "false";
			OnFailure = "";
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; ['primary_9', ''] call vn_mf_fnc_task_create";
			NextSubtasks[] = {};
			Pos[] = {"random", {{""}, {"water"}}};
		};
	};
};

class primary_9 : simple_task_system_task
{
	taskcategory = "PRI";
	taskmarker = "";
	tasktitle = "Destroy VC HQ";
	taskname = "Locate and Destroy local VC HQ";
	taskdesc = "Locate and Destroy local VC HQ";
	tasktype = "attack";
	taskimage = "vn\missions_f_vietnam\data\img\mikeforce\p\vn_ui_mf_task_p9.jpg";
	taskprogress = 100;

	//The script called when the task is created.
	taskScript = "vn_mf_fnc_state_machine_task_system";

	//Data for the script to use to customise behaviour
	class parameters {
		stateMachineCode = "vn_mf_fnc_task_pri_9";
		spawnPosition[] = {"marker", ''};
	};

	//Data for subtasks. These are specific to the script.
	class destroy_hq {
		taskname = "Destroy the HQ";
		taskdesc = "We've identified the position of their local HQ. Eliminate it.";
	};
};


#include ".\ba_ria\tasks.hpp"
#include ".\saigon\tasks.hpp"
