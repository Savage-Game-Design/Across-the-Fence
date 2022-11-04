/*
    File: fn_init_info_panel_handler_loop.sqf
    Author: Gus Schultz
    Date: 2022-09-18
    Last Update: 
    Public: /shrug

    Description:
        setup the info panel handler

    Parameter(s):
        N/A

    Returns: nothing

    Example(s):
        call vgm_c_fnc_info_panel_handler_loop;
        
*/

//DEV (ToDo): Until client Scheduler is added:
[]spawn
{
    systemchat "starting infopanel handler loop";
    "para_infopanel" cutRsc ["para_infopanel", "PLAIN", -1, true];
    while{true}do
    {
        uisleep 0.5;
        [] call para_c_fnc_infopanel_handler;
    };
};