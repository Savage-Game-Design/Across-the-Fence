class primary_1_saigon : primary_1
{
	taskmarker = "zone_saigon";
	tasktitle = "Build Saigon Checkpoint";
	taskname = "Build Saigon Checkpoint";

	class setup_checkpoints: setup_checkpoints {
		taskdesc = "Head to Saigon, in order to establish checkpoints";

		class parameters: parameters {
			Pos[] = {"marker", "zone_saigon"};
		};
	};

	class build_checkpoint: build_checkpoint {
		taskdesc = "Build the checkpoint in Saigon.";

		class parameters: parameters {
			OnSuccess = "private _nextTask = selectRandom ['primary_2a_saigon', 'primary_2b_saigon']; [_nextTask, 'saigon'] call vn_mf_fnc_task_create; [_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete;";
			Pos[] = {"marker", "zone_saigon"};
		};
	};
};

class primary_2a_saigon : primary_2a
{
	taskmarker = "zone_saigon";

	class deliver_supplies: deliver_supplies {
		class parameters: parameters {
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; ['primary_3_saigon', 'saigon'] call vn_mf_fnc_task_create";
			Pos[] = {"random", {{"zone_saigon"}, {"water"}}};
		};
	};
};

class primary_2b_saigon : primary_2b
{
	taskmarker = "zone_saigon";

	class build_aid_post: build_aid_post {
		class parameters: parameters {
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; ['primary_3_saigon', 'saigon'] call vn_mf_fnc_task_create";
			Pos[] = {"random", {{"zone_saigon"}, {"water"}}};
		};
	};
};

class primary_3_saigon : primary_3
{
	taskmarker = "zone_saigon";
	class patrol_area: patrol_area {
		class parameters: parameters {
			Pos[] = {"random",{{"zone_saigon"},{"water"}}};
		};
	};

	class patrol_area_2: patrol_area_2 {
		class parameters: parameters {
			Pos[] = {"random",{{"zone_saigon"},{"water"}}};
		};
	};

	class talk_to_civilian: talk_to_civilian {
		class parameters: parameters {
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; private _nextTask = selectRandom ['primary_4a_saigon', 'primary_4b_saigon']; [_nextTask, 'saigon'] call vn_mf_fnc_task_create;";
			Pos[] = {"random",{{"zone_saigon"},{"water"}}};
		};
	};
};

// p4a Locate and destroy
class primary_4a_saigon : primary_4a
{
	class destroy_bunker: destroy_bunker {
		class parameters: parameters {
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; ['primary_5_saigon', 'saigon'] call vn_mf_fnc_task_create;";
			Pos[] = {"random",{{"zone_saigon"},{"water"}}};
		};
	};
};


// p4b Kill the VC tax collector to protect the zone
class primary_4b_saigon : primary_4b
{
	taskmarker = "zone_saigon";
	class find_tax_collector: find_tax_collector {
		class parameters: parameters {
			OnFailure = "[_taskDataStore, 'FAILED'] call vn_mf_fnc_task_complete; ['primary_7_saigon', 'saigon'] call vn_mf_fnc_task_create;";
			Pos[] = {"random",{{"zone_saigon"},{"water"}}};
		};
	};

	class kill_tax_collector: kill_tax_collector {
		class parameters: parameters {
			OnFailure = "[_taskDataStore, 'FAILED'] call vn_mf_fnc_task_complete; ['primary_7_saigon', 'saigon'] call vn_mf_fnc_task_create;";
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; ['primary_5_saigon', 'saigon'] call vn_mf_fnc_task_create;";
		};
	};
};

class primary_5_saigon : primary_5
{
	taskmarker = "zone_saigon";
	class take_building_supplies: take_building_supplies {
		class parameters: parameters {
			Pos[] = {"random",{{"zone_saigon"},{"water"}}};
		};
	};

	class build_school: build_school {
		class parameters: parameters {
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; private _nextTask = selectRandom ['primary_6a_saigon', 'primary_6b_saigon']; [_nextTask, 'saigon'] call vn_mf_fnc_task_create;";
			Pos[] = {"marker", "zone_saigon"};
		};
	};
};

class primary_6a_saigon : primary_6a
{
	taskmarker = "zone_saigon";
	class go_to_zone: go_to_zone {
		class parameters: parameters {
			Pos[] = {"random",{{"zone_saigon"},{"water"}}};
		};
	};

	//Data for subtasks. These are specific to the script.
	class defend_village: defend_village {
		class parameters: parameters {
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; ['primary_7_saigon', 'saigon'] call vn_mf_fnc_task_create;";
		};
	};
};

// Ambush the VC recruiters
class primary_6b_saigon : primary_6b
{
	taskmarker = "zone_saigon";
	class go_to_ambush: go_to_ambush {
		class parameters: parameters {
			Pos[] = {"random",{{"zone_saigon"},{"water"}}};
		};
	};

	class kill_vc: kill_vc {
		class parameters: parameters {
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; ['primary_7_saigon', 'saigon'] call vn_mf_fnc_task_create;";
		};
	};

};

// Escort the elders to the meeting
class primary_7_saigon : primary_7
{
	taskmarker = "zone_saigon";

	class meet_elders: meet_elders {
		class parameters: parameters {
			Pos[] = {"random",{{"zone_saigon"},{"water"}}};
		};
	};

	class escort_elders: escort_elders {
		class parameters: parameters {
			Pos[] = {"random",{{"zone_saigon"},{"water"}}};
		};
	};

	class defend_meeting: defend_meeting {
		class parameters: parameters {
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; private _nextTask = selectRandom ['primary_8a_saigon']; [_nextTask, 'saigon'] call vn_mf_fnc_task_create;";
		};
	};
};

class primary_8a_saigon : primary_8a
{
	taskmarker = "zone_saigon";

	class deliver_supplies: deliver_supplies {
		class parameters: parameters {
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; ['primary_9_saigon', 'saigon'] call vn_mf_fnc_task_create";
			Pos[] = {"random", {{"zone_saigon"}, {"water"}}};
		};
	};
};

class primary_9_saigon : primary_9
{
	taskmarker = "zone_saigon";
	onCompletion = "call vn_mf_fnc_end_mission";

	class parameters: parameters {
		spawnPosition[] = {"marker", "zone_saigon"};
	};
};
