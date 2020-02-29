class secondary_ac2 : task
{
	taskcategory = "SEC";
	taskmarker = "";
	tasktitle = "Clear Minefield";
	taskname = "Clear Minefield";
	taskdesc = "A minefield has been spotted near this location. Clear it of mines and VC traps.";
	tasktype = "mine";
	taskimage = "vn\missions_f_vietnam\data\img\mikeforce\s\vn_ui_mf_task_ac2.jpg";
	taskgroups[] = {"ACAV"};
	rankpoints = 1;
	taskprogress = 0;

	//The script called when the task is created.
	taskScript = "vn_mf_fnc_state_machine_task_system";

	//Data for the script to use to customise behaviour
	class parameters 
	{
		stateMachineCode = "vn_mf_fnc_task_sec_clear_minefield";
	};

	//Data for subtasks. These are specific to the script.
	class find_minefield 
	{
		taskname = "Find Minefield";
		taskdesc = "Find the minefield near the given marker.";
	};

	class disarm_minefield
	{
		taskname = "Clear Minefield";
		taskdesc = "Clear the minefield of traps and mines.";
	};
};