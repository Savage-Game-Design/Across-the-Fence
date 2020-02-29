class support_gh_cas : support_task
{
	taskcategory = "SUP";
	tasktitle = "Close Air Support";
	taskname = "Close Air Support";
	taskdesc = "Provide close air support to %1";
	tasktype = "attack";
	taskimage = "vn\missions_f_vietnam\data\img\mikeforce\s\vn_ui_mf_task_gh3.jpg";
	taskgroups[] = {"GreenHornets"};
	requestgroups[] = {"GreenHornets", "MikeForce", "SpikeTeam"};
	rankpoints = 1;
	taskprogress = 0;

	//The script called when the task is created.
	taskScript = "vn_mf_fnc_state_machine_task_system";

	//Data for the script to use to customise behaviour
	class parameters 
	{
		stateMachineCode = "vn_mf_fnc_task_sup_cas";
	};

	//Data for subtasks. These are specific to the script.
	class destroy_targets 
	{
		taskname = "Destroy units in area";
		taskdesc = "Destroy enemy units in this area.";
	};
};