class secondary_mf1 : task
{
	taskcategory = "SEC";
	taskmarker = "";
	tasktitle = "Reinforce ARVN";
	taskname = "Reinforce ARVN";
	taskdesc = "Reinforce troops at their location";
	tasktype = "defend";
	taskimage = "vn\missions_f_vietnam\data\img\mikeforce\s\vn_ui_mf_task_mf1.jpg";
	taskgroups[] = {"MikeForce"};
	rankprogress = 4;
	taskprogress = 4;

	taskScript = "vn_mf_fnc_state_machine_task_system";

	//Data for the script to use to customise behaviour
	class parameters 
	{
		stateMachineCode = "vn_mf_fnc_task_sec_reinforce";
	}

	class defend_troops {
		taskname = "Defend Troops";
		taskdesc = "Reinforce troops at their location";
	};

	class talk_to_commander {
		taskname = "Talk to Commander";
		taskdesc = "Talk to Commander";
	};
};


class secondary_mf3 : task
{
	taskcategory = "SEC";
	taskmarker = "";
	tasktitle = "Destroy the Camp";
	taskname = "Destroy the Camp";
	taskdesc = "There's rumours of a VC camp in the area. Find it, eliminate it.";
	taskgroups[] = {"MikeForce"}; // all
	tasktype = "attack";
	taskimage = "vn\missions_f_vietnam\data\img\mikeforce\s\vn_ui_mf_task_mf3.jpg";
	rankpoints = 4;
	taskprogress = 4;

	//The script called when the task is created.
	taskScript = "vn_mf_fnc_state_machine_task_system";

	//Data for the script to use to customise behaviour
	class parameters 
	{
		stateMachineCode = "vn_mf_fnc_task_sec_destroy_camp";
	};

	class find_and_destroy_camp 
	{
		taskname = "Find and Destroy the Camp";
		taskdesc = "Find and destroy the camp that's somewhere near this point.";
	};
};
