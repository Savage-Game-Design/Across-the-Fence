class support_resupply : support_task
{
	taskcategory = "SUP";
	tasktitle = "Resupply";
	taskname = "Resupply";
	taskdesc = "Transport the supplies to the position given by %1.";
	tasktype = "box";
	taskimage = "vn\missions_f_vietnam\data\img\mikeforce\s\vn_ui_mf_task_ac1.jpg";
	taskgroups[] = {"ACAV", "GreenHornets"};
	requestgroups[] = {"MikeForce","SpikeTeam"};
	rankpoints = 1;
	taskprogress = 0;

	//The script called when the task is created.
	taskScript = "vn_mf_fnc_state_machine_task_system";

	//Data for the script to use to customise behaviour
	class parameters {
		stateMachineCode = "vn_mf_fnc_task_sup_resupply";
		crateSpawnPosition[] = {"marker", "respawn_west_acav"};
	};

	//Data for subtasks. These are specific to the script.
	class collect_crate {
		taskname = "Collect Resupply Crate";
		taskdesc = "Collect the resupply crate from the specified location.";

		//Data to customise
		//These are specific to each subtask for each mission - see mission documentation.
		class parameters {
		};
	};

	class deliver_crate {
		taskname = "Deliver Resupply Crate";
		taskdesc = "Deliver the resupply crate to the units that need it.";

		//Data to customise
		//These are specific to each subtask for each mission - see mission documentation.
		class parameters {
		};
	};
};

class support_insertion : support_task
{
	taskcategory = "SUP";
	tasktitle = "Insert the squad";
	taskname = "Insert the squad";
	taskdesc = "Insert %1 at the given position. They must make it in alive.";
	tasktype = "land";
	taskimage = "vn\missions_f_vietnam\data\img\mikeforce\su\vn_ui_mf_task_ghs2.jpg";
	taskgroups[] = {"ACAV", "GreenHornets"};
	//TODO: Remove GreenHornets and ACAV
	requestgroups[] = {"MikeForce","SpikeTeam", "GreenHornets", "ACAV"};
	rankpoints = 1;
	taskprogress = 0;

	//The script called when the task is created.
	taskScript = "vn_mf_fnc_state_machine_task_system";

	//Data for the script to use to customise behaviour
	class parameters {
		stateMachineCode = "vn_mf_fnc_task_sup_transport";
		startPos[] = {"marker", "respawn_west_greenhornets"};
		destinationPos[] = {"supportPos"};
	};

	//Data for subtasks. These are specific to the script.
	class mount {
		taskname = "Collect the squad";
		taskdesc = "Collect the squad from the given position. Everyone must be aboard in order to leave.";
	};

	class transport {
		taskname = "Insert the squad";
		taskdesc = "Insert the squad at the given position. At least one squad member must make it to the position alive.";
	};
};

class support_extraction : support_task
{
	taskcategory = "SUP";
	tasktitle = "Extract the squad";
	taskname = "Extract the squad";
	taskdesc = "Extract %1 from the given position. They must make it out alive.";
	tasktype = "land";
	taskgroups[] = {"ACAV", "GreenHornets"};
	//TODO: Remove GreenHornets and ACAV
	requestgroups[] = {"MikeForce","SpikeTeam", "GreenHornets", "ACAV"};
	rankpoints = 1;
	taskprogress = 0;

	//The script called when the task is created.
	taskScript = "vn_mf_fnc_state_machine_task_system";

	//Data for the script to use to customise behaviour
	class parameters {
		stateMachineCode = "vn_mf_fnc_task_sup_transport";
		startPos[] = {"supportPos"};
		destinationPos[] = {"marker", "respawn_west_greenhornets"};
	};

	//Data for subtasks. These are specific to the script.
	class mount {
		taskname = "Extract the squad";
		taskdesc = "Extract the squad from the given position. Everyone left alive must be aboard in order to leave.";
	};

	class transport {
		taskname = "Return to base";
		taskdesc = "Return the squad to base. At least one squad member must be returned alive.";
	};
};

#include "acav\tasks.hpp"
#include "greenhornets\tasks.hpp"
#include "mikeforce\tasks.hpp"
#include "spiketeam\tasks.hpp"