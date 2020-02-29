// add notes about current build settings
player createDiaryRecord ["Diary", [localize "STR_vn_mf_howtobuild", localize "STR_vn_mf_howtobuild_long"], taskNull, "", false];

// display initial loading text
[parseText format["<t font='VeteranTypewriter' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading1"]] call vn_mf_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.2;
// add event handlers
call vn_mf_fnc_init_public_variable_event_handlers;
[parseText format["<t font='VeteranTypewriter' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading2"]] call vn_mf_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.3;
// add display event handlers
call vn_mf_fnc_init_display_event_handler;
[parseText format["<t font='VeteranTypewriter' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading3"]] call vn_mf_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.4;
// add player event handlers
call vn_mf_fnc_init_player_event_handlers;
[parseText format["<t font='VeteranTypewriter' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading4"]] call vn_mf_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.5;
// add self actions
call vn_mf_fnc_action_drink_water;
[parseText format["<t font='VeteranTypewriter' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading5"]] call vn_mf_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.6;
// add self actions
call vn_mf_fnc_action_eat_food;
[parseText format["<t font='VeteranTypewriter' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading6"]] call vn_mf_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.7;
// create UI
0 spawn vn_mf_fnc_ui_create;
[parseText format["<t font='VeteranTypewriter' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading7"]] call vn_mf_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.8;
// master loop
0 spawn vn_mf_fnc_master_loop_init;
[parseText format["<t font='VeteranTypewriter' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading8"]] call vn_mf_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.9;
// add supply officer actions
call vn_mf_fnc_action_supplies;
[parseText format["<t font='VeteranTypewriter' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading9"]] call vn_mf_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 1.0;
// add duty officer teleport actions
call vn_mf_fnc_action_teleport;
[parseText format["<t font='VeteranTypewriter' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading10"]] call vn_mf_fnc_update_loading_screen;

// end loading screen
uiSleep 0.4;
endLoadingScreen;


// display location after a little delay
sleep 4;
call vn_mf_fnc_display_location_time;
