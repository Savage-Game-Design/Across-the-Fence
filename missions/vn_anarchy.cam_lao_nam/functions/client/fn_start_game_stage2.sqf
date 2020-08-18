/*
    File: fn_start_game_stage2.sqf
    Author: Aaron Clark <vbawol>
    Date: 2020-05-16
    Last Update: 2020-05-28
    Public: No

    Description:
	    Starts second login phase.

    Parameter(s): none

    Returns: nothing

    Example(s):
    	// Ran from Server
	    [] remoteExec ["vn_an_fnc_start_game_stage2",_player];
*/

// add notes about current build settings
0 fadeSound 0;
player createDiaryRecord ["Diary", [localize "STR_vn_mf_howtobuild", localize "STR_vn_mf_howtobuild_long"], taskNull, "", false];

player createDiaryRecord ["Diary", [localize "STR_vn_mf_other_keys", localize "STR_vn_mf_other_keys_long"], taskNull, "", false];



// display initial loading text
[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading1"]] call vn_an_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.2;

[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading2"]] call vn_an_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.3;
// add display event handlers
call para_c_fnc_init_display_event_handler;
[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading3"]] call vn_an_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.4;
// add player event handlers
call para_c_fnc_init_player_event_handlers;
[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading4"]] call vn_an_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.5;

[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading5"]] call vn_an_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.6;

[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading6"]] call vn_an_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.7;
// create UI
// 0 spawn vn_mf_fnc_ui_create;
[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading7"]] call vn_an_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.8;
// master loop
0 spawn para_c_fnc_compiled_loop_init;
[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading8"]] call vn_an_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.9;
[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading9"]] call vn_an_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 1.0;

[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading10"]] call vn_an_fnc_update_loading_screen;

// Start AI processing for local player, if we're not a LAN server (as then serverside processing will kick in)
if (!isServer) then {
	call para_g_fnc_ai_create_behaviour_execution_loop;
};

// end loading screen
uiSleep 0.4;
endLoadingScreen;

4 fadeSound 1;

// display location after a little delay
sleep 4;
// call vn_mf_fnc_display_location_time;


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
