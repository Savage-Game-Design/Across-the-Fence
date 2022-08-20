/*
    File: para_server_init.sqf
    Author: Savage Game Design
    Public: Yes

    Description:
        Called to initialise the server on game start.

    Parameter(s):
        None

    Returns:
        None

    Example(s):
        //In description.ext
        use_paradigm_init = 1;
*/

private _gamemode_config = (missionConfigFile >> "gamemode");

//Set whether the building system needs vehicles (fuel/repair/rearm, etc) nearby to build certain structures.
para_l_buildables_require_vehicles = [false, true] select (["buildables_require_vehicles", 1] call BIS_fnc_getParamValue);
publicVariable "para_l_buildables_require_vehicles";
vn_mf_dawnLength = ["dawn_length", 1200] call BIS_fnc_getParamValue;
vn_mf_dayLength = ["day_length", 9000] call BIS_fnc_getParamValue;
vn_mf_duskLength = ["dusk_length", 1200] call BIS_fnc_getParamValue;
vn_mf_nightLength = ["night_length", 1800] call BIS_fnc_getParamValue;

//Set whether withstand is always available.
vn_revive_withstand_allow = (["always_allow_withstand", 1] call BIS_fnc_getParamValue) > 0;
publicVariable "vn_revive_withstand_allow";
//Set number of bandages needed to withstand.
vn_revive_withstand_amount = 4;
publicVariable "vn_revive_withstand_amount";

// Set number of enemies per player.
para_g_enemiesPerPlayer = 2;
//Global variable, so it needs syncing across the network.
publicVariable "para_g_enemiesPerPlayer";

// setup game optimizations server side
setviewdistance (getNumber(_gamemode_config >> "performance" >> "setviewdistance"));
setobjectviewdistance (getArray(_gamemode_config >> "performance" >> "setobjectviewdistance")); // this also controls ai target range
setterraingrid (getNumber(_gamemode_config >> "performance" >> "setterraingrid"));
(getArray(_gamemode_config >> "performance" >> "enableenvironment")) params ["_ambientlife","_ambientsound"];
enableenvironment [[false,true] select _ambientlife,[false,true] select _ambientsound];

// start scheduler
diag_log "VGM: Starting scheduler";
[] call para_g_fnc_scheduler_subsystem_init;

// start the event dispatcher, so anything relying on events can fire.
call para_g_fnc_event_subsystem_init;

diag_log "VGM: Initialising Cleanup Routine";
// start cleanup subsystem
[
    createHashmapFromArray [
        ["minPlayerDistance", ["cleanup_min_player_distance", 400] call BIS_fnc_getParamValue],
        ["maxBodies", ["cleanup_max_bodies", 50] call BIS_fnc_getParamValue],
        ["cleanPlacedGear", ["cleanup_placed_gear", 1] call BIS_fnc_getParamValue > 0],
        ["placedGearCleanupTime", ["cleanup_placed_gear_lifetime", 300] call BIS_fnc_getParamValue],
        ["cleanDroppedGear", ["cleanup_dropped_gear", 1] call BIS_fnc_getParamValue > 0],
        ["droppedGearCleanupTime", ["cleanup_dropped_gear_lifetime", 300] call BIS_fnc_getParamValue]
    ]
] call para_s_fnc_cleanup_subsystem_init;

{
    private _taskConfig = _x;
    //Add the task to appropriate team arrays for the zone
    {
        vn_mf_secondaryTasksBySide getVariable _x pushBack configName _taskConfig;
    } forEach (getArray (_taskConfig >> 'taskGroups'));
} forEach (vn_mf_secondaryTaskConfigs);

diag_log "VGM: Starting building state tracker";
// building state tracking
["building_state_tracker", {call para_s_fnc_building_state_tracker}, [], 60] call para_g_fnc_scheduler_add_job;

diag_log "VGM: Starting player list tracker";
// do slow allplayers list updates
["loadbal_fps_aggregator", {call para_s_fnc_loadbal_fps_aggregator}, [], 15] call para_g_fnc_scheduler_add_job;

// Clear Trees
["GET", "chopped_trees", ""] call para_s_fnc_profile_db params ["","_chopped_trees"];
if !(_chopped_trees isEqualType "") then {
    {[_x] call para_s_fnc_fell_tree_initial;} forEach (_chopped_trees # 0);
};

//Set date here - it's as good a place as any. Day is just before a full moon, for good night ops.
[vn_mf_dawnLength, vn_mf_dayLength, vn_mf_duskLength, vn_mf_nightLength] call para_s_fnc_day_night_subsystem_init;

diag_log "VN MikeForce: Initialising Loadbalancer";
//Initialise the AI loadbalancer.
[] call para_s_fnc_loadbal_subsystem_init;

diag_log "VN MikeForce: Initialising AI Objectives";
// start ai subsystem. Depends on the load balancer subsystem.
[
    ["hardAiLimit", ["hard_ai_limit", 80] call BIS_fnc_getParamValue]
] call para_s_fnc_ai_obj_subsystem_init;

diag_log "VN MikeForce: Initialising Harass";
// Start harassment subsystem. Depends on the AI subsystem.
[] call para_s_fnc_harass_subsystem_init;

diag_log "VN MikeForce: Initialising AI Behaviour";
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

/*
diag_log "VN MikeForce: Initialising Performance Logging";
[] call vn_mf_fnc_init_performance_logging;
*/

diag_log "VN MikeForce: Initialising Dynamic Groups";
["Initialize"] call para_c_fnc_dynamicGroups;
