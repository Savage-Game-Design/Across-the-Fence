/*
    File: fn_startScheduler.sqf
    Author: Savage Game Design
    Date: 2023-09-22
    Last Update: 2023-09-22
    Public: Yes

    Description:
        Starts executing the paradigm script scheduler
        An equivalent to BIS_fnc_loop that runs in a scheduled environment.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] call vgm_g_fnc_startScheduler;
 */

[] call para_g_fnc_scheduler_subsystem_init;
