/*
    File: fn_ai_create_behaviour_execution_loop.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:
		Spawns a loop on the given client that executes behaviours on all necessary AI groups
    
    Parameter(s):
		None
    
    Returns:
        None
    
    Example(s):
		call para_g_fnc_ai_create_behaviour_execution_loop
*/

//The behaviour script is responsible for executing behaviours on all local AI groups.
if (isNil "para_l_behaviourExecutionScript" || {scriptDone para_l_behaviourExecutionScript}) then {
	para_l_behaviourExecutionScript = [] spawn {
		while {true} do {
			call para_g_fnc_ai_run_behaviours_all_groups;
			sleep 3;
		};
	};
};

//The monitor script is responsible for restarting the main behaviour loop if it crashes.
if (isNil "para_l_behaviourMonitorScript" || {scriptDone para_l_behaviourMonitorScript}) then {
	para_l_behaviourMonitorScript = [] spawn {
		while {true} do {
			call para_g_fnc_ai_create_behaviour_execution_loop;
			uisleep 20;
		};
	};
};