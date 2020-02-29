class primary_1_ba_ria : primary_1
{
	taskmarker = "zone_ba_ria";
	tasktitle = "Build Ba Ria Checkpoint";
	taskname = "Build Ba Ria Checkpoint";

	class setup_checkpoints: setup_checkpoints {
		taskdesc = "Head to Ba Ria, in order to establish checkpoints";

		class parameters: parameters {
			Pos[] = {"marker", "zone_ba_ria"};
		};
	};

	class build_checkpoint: build_checkpoint {
		taskdesc = "Build the checkpoint in Ba Ria.";

		class parameters: parameters {
			OnSuccess = "private _nextTask = selectRandom ['primary_2a_ba_ria', 'primary_2b_ba_ria']; [_nextTask, 'zone_ba_ria'] call vn_mf_fnc_task_create; [_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete;";
			Pos[] = {"marker", "zone_ba_ria"};
		};
	};
};

class primary_2a_ba_ria : primary_2a
{
	taskmarker = "zone_ba_ria";

	class deliver_supplies: deliver_supplies {
		class parameters: parameters {
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; ['primary_3_ba_ria', 'zone_ba_ria'] call vn_mf_fnc_task_create";
			Pos[] = {"random", {{"zone_ba_ria"}, {"water"}}};
		};
	};
};

class primary_2b_ba_ria : primary_2b
{
	taskmarker = "zone_ba_ria";

	class build_aid_post: build_aid_post {
		class parameters: parameters {
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; ['primary_3_ba_ria', 'zone_ba_ria'] call vn_mf_fnc_task_create";
			Pos[] = {"random", {{"zone_ba_ria"}, {"water"}}};
		};
	};
};

class primary_3_ba_ria : primary_3
{
	taskmarker = "zone_ba_ria";
	class patrol_area: patrol_area {
		class parameters: parameters {
			Pos[] = {"random",{{"zone_ba_ria"},{"water"}}};
		};
	};

	class patrol_area_2: patrol_area_2 {
		class parameters: parameters {
			Pos[] = {"random",{{"zone_ba_ria"},{"water"}}};
		};
	};

	class talk_to_civilian: talk_to_civilian {
		class parameters: parameters {
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; private _nextTask = selectRandom ['primary_4a_ba_ria', 'primary_4b_ba_ria']; [_nextTask, 'zone_ba_ria'] call vn_mf_fnc_task_create;";
			Pos[] = {"random",{{"zone_ba_ria"},{"water"}}};
		};
	};
};

// p4a Locate and destroy
class primary_4a_ba_ria : primary_4a
{
	class destroy_bunker: destroy_bunker {
		class parameters: parameters {
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; ['primary_5_ba_ria', 'zone_ba_ria'] call vn_mf_fnc_task_create;";
			Pos[] = {"random",{{"zone_ba_ria"},{"water"}}};
		};
	};
};


// p4b Kill the VC tax collector to protect the zone
class primary_4b_ba_ria : primary_4b
{
	taskmarker = "zone_ba_ria";
	class find_tax_collector: find_tax_collector {
		class parameters: parameters {
			OnFailure = "[_taskDataStore, 'FAILED'] call vn_mf_fnc_task_complete; ['primary_7_ba_ria', 'zone_ba_ria'] call vn_mf_fnc_task_create;";
			Pos[] = {"random",{{"zone_ba_ria"},{"water"}}};
		};
	};

	class kill_tax_collector: kill_tax_collector {
		class parameters: parameters {
			OnFailure = "[_taskDataStore, 'FAILED'] call vn_mf_fnc_task_complete; ['primary_7_ba_ria', 'zone_ba_ria'] call vn_mf_fnc_task_create;";
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; ['primary_5_ba_ria', 'zone_ba_ria'] call vn_mf_fnc_task_create;";
		};
	};
};

class primary_5_ba_ria : primary_5
{
	taskmarker = "zone_ba_ria";
	class take_building_supplies: take_building_supplies {
		class parameters: parameters {
			Pos[] = {"random",{{"zone_ba_ria"},{"water"}}};
		};
	};

	class build_school: build_school {
		class parameters: parameters {
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; private _nextTask = selectRandom ['primary_6a_ba_ria', 'primary_6b_ba_ria']; [_nextTask, 'zone_ba_ria'] call vn_mf_fnc_task_create;";
			Pos[] = {"marker", "zone_ba_ria"};
		};
	};
};

class primary_6a_ba_ria : primary_6a
{
	taskmarker = "zone_ba_ria";
	class go_to_zone: go_to_zone {
		class parameters: parameters {
			Pos[] = {"random",{{"zone_ba_ria"},{"water"}}};
		};
	};

	//Data for subtasks. These are specific to the script.
	class defend_village: defend_village {
		class parameters: parameters {
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; ['primary_7_ba_ria', 'zone_ba_ria'] call vn_mf_fnc_task_create;";
		};
	};
};

// Ambush the VC recruiters
class primary_6b_ba_ria : primary_6b
{
	taskmarker = "zone_ba_ria";
	class go_to_ambush: go_to_ambush {
		class parameters: parameters {
			Pos[] = {"random",{{"zone_ba_ria"},{"water"}}};
		};
	};

	class kill_vc: kill_vc {
		class parameters: parameters {
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; ['primary_7_ba_ria', 'zone_ba_ria'] call vn_mf_fnc_task_create;";
		};
	};

};

// Escort the elders to the meeting
class primary_7_ba_ria : primary_7
{
	taskmarker = "zone_ba_ria";

	class meet_elders: meet_elders {
		class parameters: parameters {
			Pos[] = {"random",{{"zone_ba_ria"},{"water"}}};
		};
	};

	class escort_elders: escort_elders {
		class parameters: parameters {
			Pos[] = {"random",{{"zone_ba_ria"},{"water"}}};
		};
	};

	class defend_meeting: defend_meeting {
		class parameters: parameters {
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; private _nextTask = selectRandom ['primary_8a_ba_ria']; [_nextTask, 'zone_ba_ria'] call vn_mf_fnc_task_create;";
		};
	};
};

class primary_8a_ba_ria : primary_8a
{
	taskmarker = "zone_ba_ria";

	class deliver_supplies: deliver_supplies {
		class parameters: parameters {
			OnSuccess = "[_taskDataStore, 'SUCCEEDED'] call vn_mf_fnc_task_complete; ['primary_9_ba_ria', 'zone_ba_ria'] call vn_mf_fnc_task_create";
			Pos[] = {"random", {{"zone_ba_ria"}, {"water"}}};
		};
	};
};

class primary_9_ba_ria : primary_9
{
	taskmarker = "zone_ba_ria";
	onCompletion = "['zone_connector', 'zone_ba_ria', [['newZone', 'zone_saigon'], ['oldZone', 'zone_ba_ria'], ['position', [16256, 4606, 0]]]] call vn_mf_fnc_task_create";

	class parameters: parameters {
		spawnPosition[] = {"marker", "zone_ba_ria"};
	};
};
