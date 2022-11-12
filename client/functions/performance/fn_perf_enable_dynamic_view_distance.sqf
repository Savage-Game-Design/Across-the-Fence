/*
    File: fn_perf_enable_dynamic_view_distance.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:
		Enables dynamic view distance scaling, in order to achieve a minimum performance goal.
    
    Parameter(s):
        _localVariable - Description [DATATYPE, defaults to DEFAULTVALUE]
    
    Returns:
        Function reached the end [BOOL]
    
    Example(s):
        [parameter] call vn_fnc_myFunction
*/
params [["_minFps", 20], ["_upscaleFps", 26]];

/* Use this to set values controlled elsewhere, to make order of initialisation not matter */
private _fnc_setIfNotSet = {
    params ["_variable", "_value"];
    if (isNil _variable) then {
        missionNamespace setVariable [_variable, _value];
    };
};

["para_c_perf_enable_dynamic_view_distance", true] call _fnc_setIfNotSet;
para_c_perf_dynamic_view_distance_is_running = false;

["para_c_perf_min_fps_to_reduce_view_distance", _minFps] call _fnc_setIfNotSet;
["para_c_perf_min_fps_to_scale_up_view", _upscaleFps] call _fnc_setIfNotSet;

para_c_perf_fps_record_freq = 2;
para_c_perf_fps_history_max_size = 5;
para_c_perf_fps_history = [];

para_c_perf_view_downscale_rate = 300;
para_c_perf_view_upscale_rate = 100;

para_c_perf_current_view_distance = viewDistance;
para_c_perf_current_object_view_distance = getObjectViewDistance select 0;
["para_c_perf_max_view_distance", para_c_perf_current_view_distance] call _fnc_setIfNotSet;
["para_c_perf_max_object_view_distance", para_c_perf_current_object_view_distance] call _fnc_setIfNotSet;
["para_c_perf_min_view_distance", 800] call _fnc_setIfNotSet;
["para_c_perf_min_object_view_distance", 800] call _fnc_setIfNotSet;

["para_c_perf_disable_dynamic_view_distance_when_flying", false] call _fnc_setIfNotSet;

["perf_auto_view_distance", { call para_c_fnc_perf_update_dynamic_view_distance }, [], para_c_perf_fps_record_freq] call para_g_fnc_scheduler_add_job;


