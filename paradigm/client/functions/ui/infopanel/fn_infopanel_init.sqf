/*
    File: fn_infopanel_init.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Adds the infopanel (for Rewards/XP gains) to the scheduler
    
    Parameter(s): none
    
    Returns: none
    
    Example(s):
		[] call para_c_fnc_infopanel_init
	
*/

#include "..\..\..\configs\ui\ui_def_base.inc"

"para_infopanel" cutRsc ["para_infopanel", "PLAIN", -1, true];
PARA_INFOPANEL_MAIN_CTRL setVariable ["timer",diag_tickTime];	//setting Timer

[
	 "para_rewards_infopanel"		//name
	,para_c_fnc_infopanel_handler	//function
	,[]								//params
	,0.5							//exec every x seconds
] call para_g_fnc_scheduler_add_job;








