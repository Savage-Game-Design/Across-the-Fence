class secondary_st2 : task
{
	taskcategory = "SEC";
	taskmarker = "";
	tasktitle = "Destroy Gun Emplacement";
	taskname = "Destroy Gun Emplacement";
	taskdesc = "Destroy the hostile gun emplacement near to the given position.";
	tasktype = "box";
	taskimage = "vn\missions_f_vietnam\data\img\mikeforce\s\vn_ui_mf_task_st2.jpg";
	taskgroups[] = {"SpikeTeam"};
	rankpoints = 1;
	taskprogress = 0;

	//The script called when the task is created.
	taskScript = "vn_mf_fnc_state_machine_task_system";

	//Data for the script to use to customise behaviour
	class parameters 
	{
		stateMachineCode = "vn_mf_fnc_task_sec_destroy_emplacement";
	};

	//Data for subtasks. These are specific to the script.
	class destroy_emplacement 
	{
		taskname = "Find and Destroy Emplacement";
		taskdesc = "Find and destroy the hostile gun emplacement in this area";
	};
};

class secondary_st3 : task
{
	taskcategory = "SEC";
	taskmarker = "";
	tasktitle = "Kill Enemy Officer";
	taskname = "Kill Enemy Officer";
	taskdesc = "Kill the enemy officer near to the target position";
	tasktype = "attack";
	taskimage = "vn\missions_f_vietnam\data\img\mikeforce\s\vn_ui_mf_task_st3.jpg";
	taskgroups[] = {"SpikeTeam"};
	rankpoints = 1;
	taskprogress = 0;

	//The script called when the task is created.
	taskScript = "vn_mf_fnc_state_machine_task_system";

	//Data for the script to use to customise behaviour
	class parameters 
	{
		stateMachineCode = "vn_mf_fnc_task_sec_kill_officer";
	};

	//Data for subtasks. These are specific to the script.
	class kill_officer 
	{
		taskname = "Find and Kill the Officer";
		taskdesc = "Find and kill the enemy officer in this area";
	};
};

