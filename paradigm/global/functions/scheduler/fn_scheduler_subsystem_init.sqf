/*
    File: fn_scheduler_subsystem_init.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:
		Starts the scheduler subsystem
    
    Parameter(s):
		None
    
    Returns:
		None
    
    Example(s):
		call para_g_fnc_scheduler_subsystem_init
*/

// Covers the case where it's called on client AND server
if (!isNil "para_l_schedulerHandle") exitWith {};
localNamespace setVariable ["para_l_scheduler_initialised", true];

call para_g_fnc_scheduler_start;
0 spawn para_g_fnc_scheduler_monitor;