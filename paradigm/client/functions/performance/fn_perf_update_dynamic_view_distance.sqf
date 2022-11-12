/*
    File: fn_perf_update_dynamic_view_distance.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
		Called periodically to update the view distance.
    
    Parameter(s):
	   	Nothing
    
    Returns:
	    Nothing
    
    Example(s):
*/

if (!para_c_perf_enable_dynamic_view_distance) exitWith {
	if (para_c_perf_dynamic_view_distance_is_running) then {
		setObjectViewDistance -1;
		setViewDistance -1;
		para_c_perf_dynamic_view_distance_is_running = false;
	};
};

para_c_perf_dynamic_view_distance_is_running = true;

private _history = para_c_perf_fps_history;
_history pushBack diag_fps;
if (count _history > para_c_perf_fps_history_max_size) then {
	_history = _history select [1, para_c_perf_fps_history_max_size];
	para_c_perf_fps_history = _history;
};

private _total = _history select 0;
{ _total = _total + _x; } forEach (_history select [1,9]);
private _average = _total / count _history;

para_c_perf_min_fps_to_scale_up_view = para_c_perf_min_fps_to_reduce_view_distance + 6;

private _isFlying = driver vehicle player isEqualTo player && vehicle player isKindOf "Air";
private _forceUpscale = _isFlying && para_c_perf_disable_dynamic_view_distance_when_flying;

if (_average < para_c_perf_min_fps_to_reduce_view_distance && !_forceUpscale) then {
	para_c_perf_current_view_distance = ((getObjectViewDistance # 0) - para_c_perf_view_downscale_rate) max para_c_perf_min_view_distance;
	para_c_perf_current_object_view_distance = (viewDistance - para_c_perf_view_downscale_rate) max para_c_perf_min_object_view_distance;
};

if (_average > para_c_perf_min_fps_to_scale_up_view || _forceUpscale) then {
	para_c_perf_current_view_distance = (viewDistance + para_c_perf_view_upscale_rate) min para_c_perf_max_view_distance;
	para_c_perf_current_object_view_distance = ((getObjectViewDistance # 0) + para_c_perf_view_upscale_rate) min para_c_perf_max_object_view_distance;
};

if (viewDistance != para_c_perf_current_view_distance) then {
	setViewDistance para_c_perf_current_view_distance;
};

if (getObjectViewDistance select 0 != para_c_perf_current_object_view_distance) then {
	setObjectViewDistance para_c_perf_current_object_view_distance;
};