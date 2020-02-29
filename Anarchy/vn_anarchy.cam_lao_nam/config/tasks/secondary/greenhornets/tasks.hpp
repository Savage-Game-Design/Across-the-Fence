class secondary_gh1 : task
{
	taskcategory = "SEC";
	taskmarker = "";
	tasktitle = "Ash and Trash";
	taskname = "Deliver Supplies to the Zone";
	taskdesc = "Deliver supplies to the Zone";
	taskgroups[] = {"GreenHornets"};
	tasktype = "upload";
	taskimage = "vn\missions_f_vietnam\data\img\mikeforce\s\vn_ui_mf_task_gh1.jpg";
	rankpoints = 0;
	taskprogress = 0;

	//The script called when the task is created.
	taskScript = "vn_mf_fnc_task_sec_transport_supplies";

	//Data for the script to use to customise behaviour
	class parameters {
	};

	//Data for subtasks. These are specific to the script.
	class load_supplies {
		taskname = "Slingload Supplies";
		taskdesc = "Deliver supplies to the zone";
	};

	class transport_supplies {
		taskname = "Move Supplies to Destination";
		taskdesc = "Deliver supplies to the zone";
	};
};

class secondary_gh6 : task
{
	taskcategory = "SEC";
	taskmarker = "";
	tasktitle = "Combat Air Patrol";
	taskname = "Combat Air Patrol";
	taskdesc = "Enemy air assets have been spotted in this area. Patrol the area and eliminate any enemy aircraft. Don't let any escape.";
	tasktype = "attack";
	taskimage = "vn\missions_f_vietnam\data\img\mikeforce\s\vn_ui_mf_task_gh6.jpg";
	taskgroups[] = {"GreenHornets"};
	rankpoints = 1;
	taskprogress = 0;

	//The script called when the task is created.
	taskScript = "vn_mf_fnc_state_machine_task_system";

	//Data for the script to use to customise behaviour
	class parameters 
	{
		stateMachineCode = "vn_mf_fnc_task_sec_combat_air_patrol";
	};

	//Data for subtasks. These are specific to the script.
	class move_to_area 
	{
		taskname = "Go to Area";
		taskdesc = "Take an armed aircraft to this location and begin patrolling.";
	};

	//Data for subtasks. These are specific to the script.
	class patrol_area 
	{
		taskname = "Patrol Area";
		taskdesc = "Patrol the area and eliminate any enemy air assets.";
	};
};