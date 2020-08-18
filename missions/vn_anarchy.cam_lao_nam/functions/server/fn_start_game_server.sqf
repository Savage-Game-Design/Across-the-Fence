/*
    File: fn_start_game_server.sqf
    Author: Aaron Clark <vbawol>
    Date: 2020-01-29
    Last Update: 2020-06-12
    Public: No

    Description:
		Initializes the server.

    Parameter(s): none

    Returns: nothing

    Example(s): none
*/

diag_log "VN Anarchy: Server Init started";

// restart every time
// ["CLEAR"] call para_s_fnc_profile_db;

if (isNil "vn_an_gamestarting") then
{
	vn_an_gamestarting = true;
	private _gamemode_config = (missionConfigFile >> "gamemode");

	// setup game optimizations server side
	setviewdistance (getNumber(_gamemode_config >> "performance" >> "setviewdistance"));
	setobjectviewdistance (getArray(_gamemode_config >> "performance" >> "setobjectviewdistance")); // this also controls ai target range
	setterraingrid (getNumber(_gamemode_config >> "performance" >> "setterraingrid"));
	(getArray(_gamemode_config >> "performance" >> "enableenvironment")) params ["_ambientlife","_ambientsound"];
	enableenvironment [[false,true] select _ambientlife,[false,true] select _ambientsound];

	// start scheduler
	diag_log "VN Anarchy: Starting scheduler";
	call para_g_fnc_scheduler_start;
	0 spawn para_g_fnc_scheduler_monitor;

	// start the event dispatcher, so anything relying on events can fire.
	call para_g_fnc_event_subsystem_init;

	// creates and initialize groups and duty officers

	//call vn_mf_fnc_group_init;


	// start generic scheduler functions
	diag_log "VN Anarchy: Starting game time monitor";
	// broadcast total time elapsed - initial
	//missionNamespace setVariable ["para_g_totalgametime",["GET", "game_time", 0] call para_s_fnc_profile_db select 1,true];
	//diag_log format ["VN Anarchy: Total Game Time - %1", para_g_totalgametime];
	//["save_time_elapsed", {call vn_mf_fnc_save_time_elapsed}, [], 5] call para_g_fnc_scheduler_add_job;

	// spawn buildables and init vars
	diag_log "VN Anarchy: Loading buildables";
	call para_s_fnc_spawn_buildables;


	diag_log "VN Anarchy: Starting building state tracker";
	// building state tracking
	["building_state_tracker", {call para_s_fnc_building_state_tracker}, [], 60] call para_g_fnc_scheduler_add_job;

	diag_log "VN Anarchy: Starting player list tracker";
	// do slow allplayers list updates
	["player_list_tracker", {call para_s_fnc_player_list_tracker}, [], 15] call para_g_fnc_scheduler_add_job;


	//Set date here - it's as good a place as any. Day is just before a full moon, for good night ops.
	// [vn_mf_dawnLength, vn_mf_dayLength, vn_mf_duskLength, vn_mf_nightLength] call para_s_fnc_day_night_subsystem_init;

	//Initialise the AI loadbalancer.
	[] call para_s_fnc_loadbal_subsystem_init;
	para_s_fnc_harass_blocked_areas = {
		vn_mf_markers_blocked_areas + vn_mf_markers_no_harass
	};

	// start ai subsystem. Depends on the load balancer subsystem.
	[] call para_s_fnc_ai_obj_subsystem_init;

	// Start harassment subsystem. Depends on the AI subsystem.
	[] call para_s_fnc_harass_subsystem_init;

	// start vehicle asset management subsystem
	// [] call vn_mf_fnc_veh_asset_subsystem_init;

	// start cleanup subsystem
	[] call para_s_fnc_cleanup_subsystem_init;

	// start vehicle creation detection subsystem
	// [] call vn_mf_fnc_veh_create_detection_subsystem_init;

	// start the behaviour subsystem
	[] call para_g_fnc_ai_behaviour_subsystem_init;

	//Set up slingloaded item locality on helicopters.
	["vehicleCreated", [
		{
			params ["_args", "_vehicle"];
			//Call it on every vehicle - it'll abort if it's not a helicopter.
			[_vehicle] call para_g_fnc_localize_slingloaded_objects;
		},
		[]
	]] call para_g_fnc_event_add_handler;

	// load zone progress
	// diag_log "VN Anarchy: Loading zone progress";
	// call vn_mf_fnc_zone_init;

	// flag server as ready
	diag_log "VN Anarchy: Marking server ready";
	missionNamespace setVariable ["vn_an_server_ready", true, true];
};


diag_log "VN: Server Init finished";
